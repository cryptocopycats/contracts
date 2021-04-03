interface WrapperContract {

    // Events

    event Wrapped(bytes5 indexed catId, uint tokenID);
    event Unwrapped(bytes5 indexed catId, uint tokenID);

    // Read contract

    function _baseURI() external view returns (string memory);

    function _catIDToTokenID(bytes5) external view returns (uint);

    function _moonCats() external view returns (address);

    function _owner() external view returns (address);

    function _tokenIDToCatID(uint) external view returns (bytes5);

    function balanceOf(address) external view returns (uint);

    function baseURI() external view returns (string memory);

    function getApproved(uint) external view returns (address);

    function isApprovedForAll(address owner, address operator) external view returns (bool);

    function name() external view returns (string memory);

    function ownerOf(uint) external view returns (address);

    function supportsInterface(bytes4) external view returns (bool);

    function symbol() external view returns (string memory);

    function tokenByIndex(uint) external view returns (uint);

    function tokenOfOwnerByIndex(address owner, uint index) external view returns (uint);

    function tokenURI(uint) external view returns (uint);

    function totalSupply() external view returns (uint);

    // Write contract

    function approve(address to, uint tokenId) external;

    function renounceOwnership() external;

    function safeTransferFrom(address from, address to, uint tokenId) external;

    function safeTransferFrom(address from, address to, uint tokenId, bytes memory _data) external;

    function setApprovalForAll(address operator, bool approved) external;

    function setBaseURI(string memory _newBaseURI) external;

    function transferFrom(address from, address to, uint tokenId) external;

    function unwrap(uint tokenId) external;

    function wrap(bytes5 catId) external;
}
