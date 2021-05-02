// File contracts/DoomCat.sol



pragma solidity ^0.8.0;



/**
 * @dev we like the cats
 */
contract DoomCat is IDoomCat, DoomCatRescue, DoomCatAuction, ERC721OnOpenSea {
    string private __baseURI;

    // there's an owner, but they can only update the BaseURI
    address public owner;

    // track the cat names here
    mapping(uint256 => string) public catNames;

    // how much does a name change cost
    uint256 public nameChangePrice;

    // reference to the token (HATE) that all funds will be swapped into
    address public immutable HATE;

    // reference to the address where all swapped HATE will be burned to
    address public immutable burn;

    // uniswap router address
    IUniswapV2Router02Minimal public immutable uniswapV2Router;

    // events for public functions
    event NameCat(address indexed account, uint256 catId, string name);
    event UpdateBaseURI(string baseURI);
    event RevokeOwner();

    constructor(
        address[4] memory addresses,
        string memory baseURI_,
        uint32 normalCats_,
        uint256[5] memory rescueDetails_,
        uint64[6] memory auctionsDetails_,
        uint256 nameChangePrice_
    )
        ERC721OnOpenSea("DoomCatRescue", "DOOM", addresses[3])
        DoomCatRescue(
            IDoomCat(address(this)),
            [
                uint256(
                    auctionsDetails_[3] * auctionsDetails_[4] + normalCats_
                ),
                normalCats_
            ],
            rescueDetails_
        )
        DoomCatAuction(IDoomCat(address(this)), auctionsDetails_)
    {
        HATE = addresses[0];
        uniswapV2Router = IUniswapV2Router02Minimal(addresses[1]);
        burn = addresses[2];
        __baseURI = baseURI_;
        owner = msg.sender;
        nameChangePrice = nameChangePrice_;
    }

    /**
     * @dev override OZ ERC721 _baseURI() function
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return __baseURI;
    }

    /**
     * @dev we want to be able to update this later, to fully decentralize it
     */
    function updateBaseURI(string calldata baseURI) public {
        require(msg.sender == owner, "not owner");
        __baseURI = baseURI;
        emit UpdateBaseURI(baseURI);
    }

    /**
     * @dev after getting baseURI into it's final form, revoke ownership
     */
    function revokeOwner() public {
        require(msg.sender == owner, "not owner");
        owner = address(0);
        emit RevokeOwner();
    }

    /**
     * @dev mint a new token to recipient with specified id, but only from current contract
     */
    function mint(address to_, uint256 tokenId_) public override {
        require(msg.sender == address(this), "can't mint");
        _mint(to_, tokenId_);
    }

    /**
     * @dev given an amount of Ether, swap all for HATE and send to burn address
     */
    function swapAndBurn(uint256 _amount) public override {
        require(msg.sender == address(this), "can't swap and burn");

        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = HATE;

        uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: _amount
        }(0, path, burn, block.timestamp);
    }

    /**
     * @dev owner of a cat can name a cat, once
     */
    function nameCat(uint256 catId, string calldata catName) external {
        require(ownerOf(catId) == msg.sender, "not your cat");

        // can only name a cat if it's not already named
        bytes memory currentName = bytes(catNames[catId]);
        require(currentName.length == 0, "already named");

        catNames[catId] = catName;
        IERC20(HATE).transferFrom(msg.sender, burn, nameChangePrice);

        emit NameCat(msg.sender, catId, catName);
    }
}

