/*

$$$$$$$\   $$$$$$\   $$$$$$\  $$\      $$\
$$  __$$\ $$  __$$\ $$  __$$\ $$$\    $$$ |
$$ |  $$ |$$ /  $$ |$$ /  $$ |$$$$\  $$$$ |
$$ |  $$ |$$ |  $$ |$$ |  $$ |$$\$$\$$ $$ |
$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ \$$$  $$ |
$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |\$  /$$ |
$$$$$$$  | $$$$$$  | $$$$$$  |$$ | \_/ $$ |
\_______/  \______/  \______/ \__|     \__|



 $$$$$$\   $$$$$$\ $$$$$$$$\
$$  __$$\ $$  __$$\\__$$  __|
$$ /  \__|$$ /  $$ |  $$ |
$$ |      $$$$$$$$ |  $$ |
$$ |      $$  __$$ |  $$ |
$$ |  $$\ $$ |  $$ |  $$ |
\$$$$$$  |$$ |  $$ |  $$ |
 \______/ \__|  \__|  \__|



$$$$$$$\  $$$$$$$$\  $$$$$$\   $$$$$$\  $$\   $$\ $$$$$$$$\
$$  __$$\ $$  _____|$$  __$$\ $$  __$$\ $$ |  $$ |$$  _____|
$$ |  $$ |$$ |      $$ /  \__|$$ /  \__|$$ |  $$ |$$ |
$$$$$$$  |$$$$$\    \$$$$$$\  $$ |      $$ |  $$ |$$$$$\
$$  __$$< $$  __|    \____$$\ $$ |      $$ |  $$ |$$  __|
$$ |  $$ |$$ |      $$\   $$ |$$ |  $$\ $$ |  $$ |$$ |
$$ |  $$ |$$$$$$$$\ \$$$$$$  |\$$$$$$  |\$$$$$$  |$$$$$$$$\
\__|  \__|\________| \______/  \______/  \______/ \________|

*/


// File contracts/DoomCatRescue.sol


pragma solidity ^0.8.0;

/**
 * @dev we rescue the cats
 */
contract DoomCatRescue {
    // reference to, basically, self
    IDoomCat private _doomCat;

    // total number of cats that exist
    uint256 public immutable totalCats;

    // how many cats initially existed to be rescued
    uint256 private immutable _remainingCatsInitial;

    // how many cats are left to be rescued
    uint256 public remainingCats;

    // when rescues can begin
    uint256 public immutable rescueStartTime;

    // initial price of rescues
    uint256 public immutable rescuePriceInitial;

    // current price of rescues
    uint256 public rescuePrice;

    // amount of rescue price increases
    uint256 public immutable rescuePriceIncrement;

    // amount of cats to rescue before price increase is triggered
    uint256 public immutable rescueTrancheSize;

    // how many blocks must exist between rescues for a given address
    uint256 public immutable rescueRateLimit;

    // track last block that an address performed a rescue
    mapping(address => uint256) public rescueLastBlock;

    // how many funds have been collected for rescues (resets every tranche)
    uint256 private collectedRescueFunds;

    event Rescue(address indexed rescuer, uint256 tokenId, uint256 price);

    constructor(
        IDoomCat doomCat_,
        uint256[2] memory catDetails_,
        uint256[5] memory rescueDetails_
    ) {
        _doomCat = doomCat_;

        totalCats = catDetails_[0];
        _remainingCatsInitial = catDetails_[1];
        remainingCats = catDetails_[1];

        rescuePriceInitial = rescueDetails_[0];
        rescuePrice = rescueDetails_[0];
        rescuePriceIncrement = rescueDetails_[1];
        rescueTrancheSize = rescueDetails_[2];
        rescueStartTime = rescueDetails_[3];
        rescueRateLimit = rescueDetails_[4];
    }

    /**
     * @dev public function to rescue a cat
     */
    function rescue() public payable {
        // require that rescues have globally started
        require(block.timestamp >= rescueStartTime, "too early");

        // require that address has passed their rate limit
        require(
            block.number >= rescueLastBlock[msg.sender] + rescueRateLimit,
            "too soon"
        );

        // require that there are cats left to be rescued
        require(remainingCats > 0, "no cats left");

        // require that the correct amount is paid (at minimum)
        require(msg.value >= rescuePrice, "value too low");

        // update address' last block rate limit tracker
        rescueLastBlock[msg.sender] = block.number;

        // grab the current rescue price (for use after updating `rescuePrice`)
        uint256 currentRescuePrice = rescuePrice;

        // update the amount of funds that have been used for rescues
        collectedRescueFunds += currentRescuePrice;

        // decrement remaining cats
        remainingCats--;

        // if we are at a tranch boundary, OR, there are no remaining cats, then
        // we want to update the price and swap & burn all collected ETH from previous
        // tranche
        if (
            (_remainingCatsInitial - remainingCats) % rescueTrancheSize == 0 ||
            remainingCats == 0
        ) {
            // if there are no more cats, set rescuePrice at 0 for cleanup sake
            if (remainingCats == 0) {
                rescuePrice = 0;
            } else {
                // otherwise, increment rescuePrice by the increment amount
                rescuePrice += rescuePriceIncrement;
            }

            // swap and burn collected funds
            _doomCat.swapAndBurn(collectedRescueFunds);

            // reset collected funds back to 0
            collectedRescueFunds = 0;
        }

        // get the tokenId for the cat to mint, mint it
        uint256 tokenId = totalCats - remainingCats;
        _doomCat.mint(msg.sender, tokenId);

        // if the user overpaid, refund their Ether
        if (msg.value > currentRescuePrice) {
            payable(msg.sender).transfer(msg.value - currentRescuePrice);
        }

        emit Rescue(msg.sender, tokenId, rescuePrice);
    }
}
