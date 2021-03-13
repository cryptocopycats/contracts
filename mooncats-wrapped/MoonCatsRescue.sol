interface MoonCatsRescue {
    struct AdoptionOffer {
        bool exists;
        bytes5 catId;
        address seller;
        uint price;
        address onlyOfferTo;
    }

    function acceptAdoptionOffer(bytes5 catId) external payable;
    function giveCat(bytes5 catId, address to) external;
    function adoptionOffers(bytes5 catId) external returns (AdoptionOffer memory);
}


