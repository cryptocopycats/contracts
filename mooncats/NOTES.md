# Notes


MidnightLightning writes
in "Developer analysis of MoonCat contract"
Source: <https://www.reddit.com/r/MoonCatRescue/comments/6tkdl0/developer_analysis_of_mooncat_contract/>


I think is a great, fun project, and so as a developer, I delved a bit into the contract code for the MoonCatRescue project, which I'll post here as a public verification of what they are claiming. I'm not affiliated with the project, though I know my way around Solidity from writing several of my own.

The main contract is at 0x60cd862c9C687A9dE49aecdC3A99b74A4fc54aB6, which is accurately noted on the website. The main logic for how to "mine" a MoonCat can be found in the `rescueCat` function (can be found on their GitHub repo [here](https://github.com/ponderware/MoonCatRescue-Contract/blob/master/contracts/MoonCatRescue.sol#L68)). The logic of the `rescueCat` function takes in a 32-byte "seed", and concatenates it to a `searchSeed` value that was the seed of the block mined with the transaction that activated the MoonCat contract. The search seed is `0x8363e7eaae8e35b1c2db100a7b0fb9db1bc604a35ce1374d882690d0b1d888e2`. The contract was activated in transaction `0x4923713f18533bd024b1ea8dc2ddf2ab6a08c6f72e4e04090d996e5749bef116` in block 4140382. The search seed is indeed the hash of the prior block, [`4140381`](https://etherscan.io/block/0x8363e7eaae8e35b1c2db100a7b0fb9db1bc604a35ce1374d882690d0b1d888e2).



The logic of whether a seed is a valid one to generate a MoonCat is a simple difficulty function check. **If the first three bytes of the keccak256 hash of the input seed concatenated to the search seed are zero, it's a valid seed.**
So that means in the 32-byte hash, the first three bytes being zero is a max of a 29-byte number (232-bit number). The website claims "There are over 4 billion unique MoonCats possible", which if you just look at valid hashes, a 232-bit number has a range of 0 through 2^232 (6.9x10^69), which is a number with 70 decimal digits (6 duovigintilliion), way bigger than 4 billion! Using that as a difficulty function, you're likely to get a correct cat hash in 1/16,777,216 hashes, so for every 8.39 million hashes, you have a 50% chance of finding a cat. However, the bit of the hash that actually gets recorded is only 4 bytes of that, which is a 32-bit number, so in the range of 0 to 2^32, which is where you get the 4 billion unique MoonCats. So you'll have a 50% chance of finding a cat every 8.39 million hashes, but there's also very good odds that it will collide with a cat already found (since only the last four bytes need to match).

If a valid seed is input, the last 4 bytes of the hash are taken and bit-shifted by 216 places (27 bytes). 27 plus 4 is 31 bytes, so that effectively shifts the last four bytes of the hash to the front of the number, leaving one byte blank (zero; which the comment indicates is a flag for is a genesis cat). That gets saved as the `catId` (and is what gets used to actually create the visual cat image).


One thing to note about the MoonCat contract is that the `catOwners` mapping is just `public`, with the default getter function, which means you can query the owner of a cat by its 5-byte ID value. However there's also a `getCatOwners` function that returns the entire database of all cat owners, but there's many duplicates (each address is in there once for each cat it owns), and there's no correlation to the cat ID that is owned. This has the side effect of making the UI of Etherscan.io a bit wonky for that contract (since it lists out that huge array on the "Read Smart Contract" tab), and it means that anyone can discover that you're a cat owner even if they don't know the ID of the cat you own. There is a separate `getCatIds` function that also exposes your ownership (getting the whole database of cat IDs allows someone to iterate through the `catOwners` mapping and find all the owners, though the `getCatOwners` makes it a lot easier).


Owning a cat allows you to offer up the cat for adoption (with a price, so more like a "sale"?), using the `makeAdoptionOffer` function. If the owner of the cat activates that function, anyone can then pay the requested amount of ether and claim the cat directly from the function (`acceptAdoptionOffer`) without any further intervention from the owner.



If you wish to adopt someone else's cat, you can put in an offer and pay some ether (`makeAdoptionRequest`). If someone else comes along and wants the same cat, they can make a request greater than yours. In which case you're credited back your ether (you need to trigger the `withdraw` function to get it back). An adoption request needs the owner to come back and accept the current offer before it's final.


The MoonCat website claims that the sale of the genesis cats burns all the ether it receives. The `addGenesisCatGroup` function allows the owner of the contract to create a batch of Genesis cats, and it does use up the next several "rescue index" spaces with the IDs of the genesis cats. And it ticks up the "number of cats owned" by the `0x00` address, but then it makes an adoption offer with the seller set to the owner of the contract (not the `0x00` address) for that genesis cat. However, the MoonCat developers are telling the truth: that `addGenesisCatGroup` does not actually update the `catOwners` mapping with the contract owner's address when the genesis cat is created. When someone accepts the open Adoption offer, the function for redeeming it does not send the money to the address that placed the adoption offer, but rather it looks the cat up in the `catOwners` mapping and pays them. Since there is no entry for the genesis cats in the `catOwners` mapping initially, that lookup comes back as zero, and is therefore interpreted as the Ethereum address `0x00`. The ether sent to adopt a genesis cat is not actually sent to the `0x00` address, but it is instead deposited into the MoonCat contract and earmarked for the `0x00` address to be able to be withdrawn. But since no private key will hash out to all zeroes, and the MoonCat contract has no "suicide" or other generic withdrawl function, those funds are effectively locked there permanently. You can see how much ether is locked up in this way by using the `pendingWithdrawals` function, putting in address `0x00` as input. As of this writing, there's 5,400,000,000,000,000,000 wei (5.4 ether) locked up like that.


One downside: if you have ether credit with the contract (either because you offered a cat up for adoption and someone paid for it, or you make an adoption request to someone else and got outbid), you cannot use that credit to adopt another cat (either claim someone else's offer, or make a request); you must withdraw it, and re-pay the contract to re-use the ether. Personally, I'd have much rather seen those funds directly transferred back to my address (since my address is the only one to be able to claim it, and it has to go back to my original address), using the gas of the person who wants to replace my bid or accept my offer as the means to trigger that transaction. As it is now, I have to pay for a separate transaction and gas in order to get my funds out, and then pay again to re-use them with the contract.

Overall a good project, and I think there's more that could be done with the cats' "ID" values, since the way they're presented, all "red" cats are about the same color (a fully-saturated red), but under the hood, their RGB values are quite different. So using those differences could show more of their "personality"...?

EDIT: Fixed my logic about how there's only 4 billion unique MoonCats.



ponderware responds:

It's worth mentioning that the aggregate getters functions (`getCatOwners`, `getCatIds`, and the rest) were implemented to make it simple for a backend webserver to aggregate all the cat information and package it up for quick delivery to users of the website. Though we didn't fully appreciate how awkward the display of the prodigious output might be on things like etherscan.

Finally, using funds in the contract without the need to withdraw them first would definitely have been a good feature. It's tough balancing additional features against their added complexity and the additional opporunities for bugs, but in this case it might have been worthwhile.





## Fixing Genesis Bug

Old - see <https://etherscan.io/address/0x60cd862c9c687a9de49aecdc3a99b74a4fc54ab6#code>:

``` soliditiy
  function addGenesisCatGroup() onlyOwner activeMode {
    require(remainingGenesisCats > 0);
    bytes5[16] memory newCatIds;
    uint256 price = (17 - (remainingGenesisCats / 16)) * 300000000000000000;
    for(uint8 i = 0; i < 16; i++) {

      uint16 genesisCatIndex = 256 - remainingGenesisCats;
      bytes5 genesisCatId = (bytes5(genesisCatIndex) << 24) | 0xff00000ca7;

      newCatIds[i] = genesisCatId;

      rescueOrder[rescueIndex] = genesisCatId;
      rescueIndex++;
      balanceOf[0x0]++;
      remainingGenesisCats--;

      adoptionOffers[genesisCatId] = AdoptionOffer(true,
                                                   genesisCatId,
                                                   owner,
                                                   price,
                                                   0x0);
    }
    GenesisCatsAdded(newCatIds);
  }
```

New in Binance MoonCat - see <https://bscscan.com/address/0x7A00B19eDc00fa5fB65F32B4D263CE753Df8f651#code>:

note: the fix is adding the missing line that adds the owner entry
to catOwners mapping (?):

``` soliditiy
catOwners[genesisCatId] = owner;
```

in full:

``` soliditiy
function addGenesisCatGroup() onlyOwner activeMode {
        require(remainingGenesisCats > 0);
        bytes5[16] memory newCatIds;
        uint256 price = (5 - (remainingGenesisCats / 16)) * 5000000000000000000;
        for(uint8 i = 0; i < 16; i++) {

            uint16 genesisCatIndex = 64 - remainingGenesisCats;
            bytes5 genesisCatId = (bytes5(genesisCatIndex) << 24) | 0xff00000ca7;

            newCatIds[i] = genesisCatId;

            rescueOrder[rescueIndex] = genesisCatId;
            rescueIndex++;
            balanceOf[owner]++;
            remainingGenesisCats--;
            catOwners[genesisCatId] = owner;

            adoptionOffers[genesisCatId] = AdoptionOffer(true,
                                                         genesisCatId,
                                                         owner,
                                                         price,
                                                         0x0);
        }
        GenesisCatsAdded(newCatIds);
    }
```

New in MarsCats - see <https://bscscan.com/address/0xd31bad66aefa525b808ee569a514f6345b0bea2d#code>

note: the fix is adding the missing line that adds the owner entry
to catOwners mapping (?):

``` soliditiy
catOwners[genesisCatId] = msg.sender;
```

in full:

``` soliditiy
    function addGenesisCatGroup(uint8 count) public onlyOwner activeMode {
        require(remainingGenesisCats > 0,"No genesis left");
        require(count<=256,"Max count is 256");
        bytes5[256] memory newCatIds;
        uint256 price = 2000000000000000000;
        for (uint8 i = 0; i < count; i++) {
            uint16 genesisCatIndex = 256 - remainingGenesisCats;
            bytes5 genesisCatId = (bytes5(genesisCatIndex) << 24) | 0xff00000ca7;

            newCatIds[i] = genesisCatId;

            rescueOrder[rescueIndex] = genesisCatId;
            rescueIndex++;

            catOwners[genesisCatId] = msg.sender;
            balanceOf[msg.sender]++;

            remainingGenesisCats--;

            adoptionOffers[genesisCatId] = AdoptionOffer(
                true,
                genesisCatId,
                owner,
                price,
                0x0
            );
        }
        emit GenesisCatsAdded(newCatIds);
    }
```