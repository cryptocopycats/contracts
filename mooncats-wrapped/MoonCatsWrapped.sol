// File: browser/MoonCatsWrapped.sol

pragma solidity ^0.7.6;
pragma abicoder v2;


contract MoonCatsWrapped is ERC721 {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;

    MoonCatsRescue public _moonCats = MoonCatsRescue(0x60cd862c9C687A9dE49aecdC3A99b74A4fc54aB6);

    mapping(bytes5 => uint) public _catIDToTokenID;
    mapping(uint => bytes5) public  _tokenIDToCatID;
    string private _baseTokenURI;
    address public _owner = 0xD2927a91570146218eD700566DF516d67C5ECFAB;


    event Wrapped(bytes5 indexed catId, uint tokenID);
    event Unwrapped(bytes5 indexed catId, uint tokenID);

    constructor() ERC721("Wrapped MoonCatsRescue", "WMCR") {}

    function setBaseURI(string memory _newBaseURI) public {
        require(_msgSender() == _owner);
        _baseTokenURI = _newBaseURI;
    }

    function renounceOwnership() public {
        require(_msgSender() == _owner);
        _owner = address(0x0);
    }


    function _baseURI() public view virtual returns (string memory) {
        return _baseTokenURI;
    }


    function wrap(bytes5 catId) public {
        MoonCatsRescue.AdoptionOffer memory offer = _moonCats.adoptionOffers(catId);
        require(offer.seller == _msgSender()); //only owner can wrap
        _moonCats.acceptAdoptionOffer(catId);


        //check if it was previously assigned
        uint tokenID = _catIDToTokenID[catId];
        uint tokenIDToAssign = tokenID;

        if (tokenID == 0) {
            tokenIDToAssign = _tokenIdTracker.current();
            _tokenIdTracker.increment();
            _catIDToTokenID[catId] = tokenIDToAssign;
            _tokenIDToCatID[tokenIDToAssign] = catId;
        }
        _mint(_msgSender(), tokenIDToAssign);
        emit Wrapped(catId, tokenIDToAssign);

    }

    function unwrap(uint256 tokenID) public {
        bytes5 catId = _tokenIDToCatID[tokenID];
        address owner = ownerOf(tokenID);
        require(owner == _msgSender()); //only owner can unwrap
        _moonCats.giveCat(catId, owner);
        _burn(tokenID);
        emit Unwrapped(catId, tokenID);
    }

}