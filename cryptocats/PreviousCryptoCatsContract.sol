contract PreviousCryptoCatsContract {

    /* You can use this hash to verify the image file containing all cats */
    string public imageHash = "e055fe5eb1d95ea4e42b24d1038db13c24667c494ce721375bdd827d34c59059";

    /* Variables to store contract owner and contract token standard details */
    address owner;
    string public standard = 'CryptoCats';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public _totalSupply;

    // Store reference to previous cryptocat contract containing alpha release owners
    // PROD
    address public previousContractAddress = 0xa185B9E63FB83A5a1A13A4460B8E8605672b6020;
    // ROPSTEN
    // address public previousContractAddress = 0x0b0DB7bd68F944C219566E54e84483b6c512737B;
    uint8 public contractVersion;
    bool public totalSupplyIsLocked;

    bool public allCatsAssigned = false;        // boolean flag to indicate if all available cats are claimed
    uint public catsRemainingToAssign = 0;   // variable to track cats remaining to be assigned/claimed
    uint public currentReleaseCeiling;       // variable to track maximum cat index for latest release

    /* Create array to store cat index to owner address */
    mapping (uint => address) public catIndexToAddress;

    /* Create an array with all balances */
    mapping (address => uint) public balanceOf;

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function PreviousCryptoCatsContract() payable {
        owner = msg.sender;                          // Set contract creation sender as owner
    }

    /* Returns count of how many cats are owned by an owner */
    function balanceOf(address _owner) constant returns (uint256 balance) {
        require(balanceOf[_owner] != 0);    // requires that cat owner balance is not 0
        return balanceOf[_owner];           // return number of cats owned from array of balances by owner address
    }

    /* Return total supply of cats existing */
    function totalSupply() constant returns (uint256 totalSupply) {
        return _totalSupply;
    }

    /* Get address of owner based on cat index */
    function getCatOwner(uint256 catIndex) public returns (address) {
        require(catIndexToAddress[catIndex] != 0x0);
        return catIndexToAddress[catIndex];             // Return address at array position of cat index
    }

    /* Get address of contract owner who performed contract creation and initialisation */
    function getContractOwner() public returns (address) {
        return owner;                                   // Return address of contract owner
    }
}