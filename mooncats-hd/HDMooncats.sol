// File: contracts/HDMooncats.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;


contract HDMooncats is Ownable, ERC721 {

    // MD5 hash of the megaimage (80k x 80k pixels) containing 25440 cats
    string public imageHash = "6d834cc1d92d2e05656da65819749732";

    address payable public mooncatsAddress = payable(0x60cd862c9C687A9dE49aecdC3A99b74A4fc54aB6);
    address public wrapperAddress = payable(0x7C40c393DC0f283F318791d746d894DdD3693572);
    string public _baseTokenURI;

    uint public minted = 0;

    address payable public splitter;
    address payable public ercRecipient;

    event Mint(address indexed owner, uint indexed _rescueOrder);

    constructor(address _feeSplitter, address _ercRecipient) payable ERC721("HD Mooncats", "HDMC") {
        splitter = payable(_feeSplitter);
        ercRecipient = payable(_ercRecipient);
    }

    /**
     * @dev Mint an HD Mooncat. The HDMC will be given to the user currently holding the OG mooncat.
     */
    function mint(uint _rescueOrder) public payable {
        // Take mint fee
        require(msg.value >= mintFee(), "Please include mint fee");

        // Check if token already exists
        require(!_exists(_rescueOrder), "Token already minted");

        bytes5 catId = MooncatsContract(mooncatsAddress).rescueOrder(_rescueOrder);
        address owner = MooncatsContract(mooncatsAddress).catOwners(catId);
        if (owner == wrapperAddress) {
            uint tokenId = WrapperContract(wrapperAddress)._catIDToTokenID(catId);
            owner = WrapperContract(wrapperAddress).ownerOf(tokenId);
        }

        _mint(owner, _rescueOrder);
        minted += 1;
        Mint(owner, _rescueOrder);
    }

    /**
     * @dev Returns the current minting fee
     */
    function mintFee() public view returns (uint) {
        if (minted <= 999) {
            return 0.01 ether;
        } else if (minted <= 4999) {
            return 0.05 ether;
        } else if (minted <= 14999) {
            return 0.10 ether;
        } else {
            return 0.20 ether;
        }
    }

    /**
     * @dev Withdraw the contract balance to the dev address
     */
    function withdraw() public {
        uint amount = address(this).balance;
        (bool success,) = splitter.call{value: amount}("");
        require(success, "Failed to send ether");
    }

    /**
     * @dev Withdraw ERC20 tokens from the contract
     */
    function withdrawFungible(address _tokenContract) public {
      ForeignToken token = ForeignToken(_tokenContract);
      uint256 amount = token.balanceOf(address(this));
      token.transfer(ercRecipient, amount);
    }

    /**
     * @dev Withdraw ERC721 tokens from the contract
     */
    function withdrawNonFungible(address _tokenContract, uint256 _tokenId) public {
        ForeignNFT(_tokenContract).transferFrom(address(this), ercRecipient, _tokenId);
    }

    /**
     * @dev Returns a URI for a given token ID's metadata
     */
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId)));
    }

    function setBaseTokenURI(string memory __baseTokenURI) public onlyOwner {
        _baseTokenURI = __baseTokenURI;
    }

}

