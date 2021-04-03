interface MooncatsContract {

    // Events

    event CatRescued(address indexed to, bytes5 indexed catId);
    event CatNamed(bytes5 indexed catId, bytes32 catName);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event CatAdopted(bytes5 indexed catId, uint price, address indexed from, address indexed to);
    event AdoptionOffered(bytes5 indexed catId, uint price, address indexed toAddress);
    event AdoptionOfferCancelled(bytes5 indexed catId);
    event AdoptionRequested(bytes5 indexed catId, uint price, address indexed from);
    event AdoptionRequestCancelled(bytes5 indexed catId);
    event GenesisCatsAdded(bytes5[16] catIds);

    // Read contract

    function name() external view returns (string memory);

    function remainingGenesisCats() external view returns (uint16);

    function totalSupply() external view returns (uint16);

    function mode() external view returns (uint8);

    function getCatDetails(bytes5) external view returns (bytes5 id, address owner, bytes32 catName, address onlyOfferTo, uint256 offerPrice, address requester, uint256 requestPrice);

    function decimals() external view returns (uint8);

    function getCatOwners() external view returns (address[] memory);

    function catOwners(bytes5 catId) external view returns (address);

    function rescueOrder(uint256 order) external view returns (bytes5 catId);

    function getCatIds() external view returns (bytes5[] memory);

    function balanceOf(address) external view returns (uint256);

    function getCatNames() external view returns (bytes32[] memory);

    function adoptionOffers(bytes5) external view returns (bool exists, bytes5 catId, address seller, uint256 price, address onlyOfferTo);

    function catNames(bytes5 catId) external view returns (bytes32);

    function symbol() external view returns (string memory);

    function getCatRequestPrices() external view returns (uint256[] memory);

    function searchSeed() external view returns (bytes32);

    function imageGenerationCodeMD5() external view returns (bytes16);

    function adoptionRequests(bytes5) external view returns (bool exists, bytes5 catId, address requester, uint256 price);

    function getCatOfferPrices() external view returns (uint256[] memory);

    function rescueIndex() external view returns (uint16);

    function pendingWithdrawals(address) external view returns (uint256);

    // Write contract

    function makeAdoptionOffer(bytes5 catId, uint256 price) external;

    function activate() external;

    function acceptAdoptionOffer(bytes5 catId) external payable;

    function withdraw() external;

    function rescueCat(bytes32 seed) external;

    function cancelAdoptionOffer(bytes5 catId) external;

    function nameCat(bytes5 catId, bytes32 catName) external;

    function activateInTestMode() external;

    function cancelAdoptionRequest(bytes5 catId) external;

    function disableBeforeActivation() external;

    function addGenesisCatGroup() external;

    function makeAdoptionOfferToAddress(bytes5 catId, uint256 price, address to) external;

    function acceptAdoptionRequest(bytes5 catId) external payable;

    function giveCat(bytes5 catId, address to) external;

}
