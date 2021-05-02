// File contracts/DoomCatAuction.sol



pragma solidity ^0.8.0;

/**
 * @dev we auction the genesis cats
 */
contract DoomCatAuction {
    // reference to, basically, self
    IDoomCat private _doomCat;

    // number of total genesis cats
    uint256 public immutable genesisCats;

    // start time of the first auction
    uint64 public immutable auctionsStart;

    // how long auctions last
    uint64 public immutable auctionsDuration;

    // time between end of one auction, and beginning of next auction
    uint64 public immutable auctionsDistance;

    // number of total auctions to perform
    uint64 public immutable auctionsCount;

    // number of cats being auctioned off per auction
    uint64 public immutable auctionsCatsPerAuction;

    // minimum bid increase amount
    uint64 public immutable auctionsBidIncrement;

    // track number of bids that have been placed for a cat
    mapping(uint256 => uint256) public bidCount;

    // track the highest bid amount for a cat
    mapping(uint256 => uint256) public highBidAmount;

    // track the owner of the highest bid for a cat
    mapping(uint256 => address) public highBidOwner;

    // track all of the bids (per address) for cats
    mapping(uint256 => mapping(address => uint256)) public bidsByTokenByAddress;

    event Bid(
        address indexed account,
        uint256 catId,
        uint256 amount,
        uint256 bidCount
    );
    event WithdrawLowBid(
        address indexed account,
        uint256 catId,
        uint256 amount
    );
    event ClaimWinningBid(
        address indexed account,
        uint256 catId,
        uint256 amount
    );

    constructor(IDoomCat doomCat_, uint64[6] memory auctionsDetails_) {
        _doomCat = doomCat_;

        genesisCats = auctionsDetails_[3] * auctionsDetails_[4];

        auctionsStart = auctionsDetails_[0];
        auctionsDuration = auctionsDetails_[1];
        auctionsDistance = auctionsDetails_[2];
        auctionsCount = auctionsDetails_[3];
        auctionsCatsPerAuction = auctionsDetails_[4];
        auctionsBidIncrement = auctionsDetails_[5];

        require(auctionsDetails_[0] >= block.timestamp, "too late");
    }

    /**
     * @dev helper function which returns two integers:
     * 1) startId: the ID of a cat which signifies the "lowest" ID of the most recent (or current) auction set
     * 2) endId: the ID of a cat which signifies the "highest" ID of the most recent (or current) auction set
     * if (startId > endId), that means that no auction is currently happening, but exposes
     *   information about the most recently completed auction
     * if (startId <= endId), that means that an auction is currently happening, for that range of IDs
     */
    function auctionsState() public view returns (uint256, uint256) {
        uint64 checkedAuctions = 0;
        uint256 startId = 0;
        uint256 endId = 0;

        // loop through each auction
        while (checkedAuctions <= auctionsCount) {
            // calculate the start time of the current auction iteration
            uint64 auctionStart =
                auctionsStart +
                    (checkedAuctions * (auctionsDuration + auctionsDistance));

            // if the auction starts in the future, we're done with this while loop
            if (auctionStart > block.timestamp) {
                break;
            }
            // otherwise, the auction is currently in progress, or over

            // regardless of in progress or over, we need to calculate the startID
            // which is done by multiplying our auction iteration by number of cats
            // per auction plus 1 because cat ids start at 1
            startId = checkedAuctions * auctionsCatsPerAuction + 1;

            // add duration to start time, compare to current timestamp, to see if
            // we're currently in auction
            if (auctionStart + auctionsDuration > block.timestamp) {
                // if we're in an auction, break the loop and don't update endId
                break;
            } else {
                // if the auction ended in the past, update endId
                endId =
                    checkedAuctions *
                    auctionsCatsPerAuction +
                    auctionsCatsPerAuction;
            }

            // iterate
            checkedAuctions++;
        }

        return (startId, endId);
    }

    /**
     * @dev how many genesis cats are remaining
     */
    function remainingGenesisCats() public view returns (uint256) {
        (, uint256 endId) = auctionsState();
        return genesisCats - endId;
    }

    /**
     * @dev place a bid for a cat, referenced by its index in the current auction
     */
    function bid(uint64 index) public payable {
        (uint256 startId, uint256 endId) = auctionsState();

        // bids can only be placed while in an auction
        require(startId > endId, "not in auction");

        // cats are referenced by their index in the auction
        require(index < auctionsCatsPerAuction, "bad index");
        uint256 catId = startId + index;

        // users may increase their bid by sending the difference of the total amount
        // they want to bid, and their current bid
        uint256 newBid = bidsByTokenByAddress[catId][msg.sender] + msg.value;

        // make sure their new bid covers the bid increment amount
        require(
            newBid >= highBidAmount[catId] + auctionsBidIncrement,
            "not enough"
        );

        // increment the bid count
        bidCount[catId] += 1;

        // set the high bid amount
        highBidAmount[catId] = newBid;

        // set the high bid owner
        highBidOwner[catId] = msg.sender;

        // set the user's bid on this cat (for withdraws, later)
        bidsByTokenByAddress[catId][msg.sender] = newBid;

        emit Bid(msg.sender, catId, newBid, bidCount[catId]);
    }

    /**
     * @dev bids which have been outbid can be "withdrawn" and their Ether returned
     * highest current bid cannot be withdrawn
     */
    function withdrawLowBid(uint256 catId) public {
        // if user is the current highest bid for the cat, no can withdraw
        require(msg.sender != highBidOwner[catId], "can't withdraw high bid");

        // get reference to their bid amount
        uint256 bidAmount = bidsByTokenByAddress[catId][msg.sender];

        // make sure the user actually has funds to withdraw
        require(bidAmount > 0, "nothing to withdraw");

        // reset their amount for this cat to 0
        bidsByTokenByAddress[catId][msg.sender] = 0;

        // send the user their funds
        payable(msg.sender).transfer(bidAmount);

        emit WithdrawLowBid(msg.sender, catId, bidAmount);
    }

    /**
     * @dev when auction is over, highest bid can claim their cat!
     */
    function claimWinningBid(uint256 catId) public {
        // confirm that the cat being claimed belongs to a completed auction
        (, uint256 endId) = auctionsState();
        require(catId <= endId, "cat not claimable");

        // if no bids have been placed on a cat, they can be claimed first-come-first-serve
        if (highBidOwner[catId] != address(0)) {
            // otherwise, require that user is the owner of highest bid
            require(msg.sender == highBidOwner[catId], "not winning bid");
        }

        // mint that cat
        _doomCat.mint(msg.sender, catId);

        // only swap & burn if a bid actually exists
        if (highBidAmount[catId] > 0) {
            _doomCat.swapAndBurn(highBidAmount[catId]);
        }

        emit ClaimWinningBid(msg.sender, catId, highBidAmount[catId]);
    }
}

