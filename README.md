Crypto Collectibles Series -
[Cats](https://github.com/cryptocopycats/contracts) ·
[Punks](https://github.com/cryptopunksnotdead/contracts)


# CryptoKitties, MoonCats & Friends Blockchain Contracts / Services

_Code on the Blockchain - Electronic Contract Scripts_


[CryptoKitties](#cryptokitties)  •
[CryptoCats](#cryptocats)  •
[MoonCats](#mooncats)  •
[MarsCats](#marscats----mooncats-remake-on-binance-ethereum-smart-chain)




## CryptoKitties

### /cryptokitties - Core CryptoKitties

Etherscan

- KittyCore, see contract address [`0x06012c8cf97bead5deae237070f9587f8e7a266d`](https://etherscan.io/address/0x06012c8cf97bead5deae237070f9587f8e7a266d#code)

> The genetic combination algorithm is kept seperate so we can open-source all of
> the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
> Don't worry, I'm sure someone will reverse engineer it soon enough!
>
> -- Commentary from the CryptoKitties source code

**Update 2019**  The sooper-sekretoo GeneScience contract
with the "magic" mixGenes function is now open source
with inline running commentary. Thanks!

- GeneScience, see contract address [`0xf97e0a5b616dffc913e72455fde9ea8bbe946a2b`](https://etherscan.io/address/0xf97e0a5b616dffc913e72455fde9ea8bbe946a2b#code)



> The auctions are
> seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
> them in their own contracts, we can upgrade them without disrupting the main contract that tracks
> kitty ownership.
>
> -- Commentary from the CryptoKitties source code


- SaleClockAuction, see contract address [`0xb1690c08e213a35ed9bab7b318de14420fb57d8c`](https://etherscan.io/address/0xb1690c08e213a35ed9bab7b318de14420fb57d8c#code)
- SiringClockAuction, see contract address [`0xc7af99fe5513eb6710e6d5f44f9989da40f27f26`](https://etherscan.io/address/0xc7af99fe5513eb6710e6d5f44f9989da40f27f26#code)




For more see [**Inside the CryptoKitties Blockchain Contracts / Services »**](cryptokitties)



### /cryptokitties-wrapped - Wrapped CryptoKitties (WCK, WG0, WVG0)


> $WCK wrapped cryptokitties; its actually backed by a digital cat;
> where as other coins are backed by hot-air.


Etherscan

- WrappedCK (WCK), see contract address [`0x09fe5f0236f0ea5d930197dce254d77b04128075`](https://etherscan.io/address/0x09fe5f0236f0ea5d930197dce254d77b04128075#code)
- WrappedG0 (WG0), see contract address [`0xa10740ff9ff6852eac84cdcff9184e1d6d27c057`](https://etherscan.io/address/0xa10740ff9ff6852eac84cdcff9184e1d6d27c057#code) - Gen 0 Variant
- WrappedVG0 (WVG0), see contract address [`0x25c7b64a93eb1261e130ec21a3e9918caa38b611`](https://etherscan.io/address/0x25c7b64a93eb1261e130ec21a3e9918caa38b611#code) - Virgin Gen 0 Variant


For more see [**Inside the Wrapped CryptoKitties (WCK, WG0, WVG0) Blockchain Contracts / Services »**](cryptokitties-wrapped)



## CryptoCats

> Cute little 8-bit cats on the Blockchain.
> Launched v3 in December 2017 with 625 vintage non-fungible tokens (NFTs),
> pre the ERC721 standard.


### /cryptocats - CryptoCatsMarket

Etherscan

- CryptoCatsMarket, see contract address [`0x088c6ad962812b5aa905ba6f3c5c145f9d4c079f`](https://etherscan.io/address/0x088c6ad962812b5aa905ba6f3c5c145f9d4c079f#code)


For more see [**Inside the CryptoCats Blockchain Contract / Service »**](cryptocats)




## MoonCats

> MoonCatRescue is an exploration of user-discoverable blockchain assets.
> Users "mine" for MoonCats in their browser.
> After MoonCats are "mined", they can be put up for adoption,
> adoptions can be requested, they can be given away,
> and they can be permanently named.
>
> Launched in August 2017 with 25,600 non-fungible tokens (NFTs) to rescue,
> pre the ERC721 standard.



### /mooncats - MoonCatRescue

Etherscan

- MoonCatResuce, see contract address [`0x60cd862c9c687a9de49aecdc3a99b74a4fc54ab6`](https://etherscan.io/address/0x60cd862c9c687a9de49aecdc3a99b74a4fc54ab6#code)


For more see [**Inside the MoonCatRescue Blockchain Contract / Service »**](mooncats)


### /mooncats-acclimated - MoonCatAcclimator

> MoonCat​Acclimator
> - accepts an original MoonCat and wraps it to present an ERC721- and ERC998-compliant asset
> - accepts a MoonCat wrapped with the older wrapping contract (at 0x7C40c3...) and re-wraps them

Etherscan

- MoonCatAcclimator, see contract address [`0xc3f733ca98E0daD0386979Eb96fb1722A1A05E69`](https://etherscan.io/address/0xc3f733ca98E0daD0386979Eb96fb1722A1A05E69#code)


For more see [**/mooncats-acclimated »**](mooncats-acclimated)


### /mooncats-wrapped - MoonCatsWrapped - Wrapped MoonCatsRescue (WMCR)

> Wrapped MoonCats Rescue is an unofficial ERC721 wrapping of the MoonCats Rescue contract.

Etherscan

- MoonCatsWrapped - Wrapped MoonCatsRescue (WMCR), see contract address [`0x7c40c393dc0f283f318791d746d894ddd3693572`](https://etherscan.io/address/0x7c40c393dc0f283f318791d746d894ddd3693572#code)


For more see [**Inside the Wrapped MoonCatsRescue (WMCR) Blockchain Contract / Service »**](mooncats-wrapped)


### /mooncats-helper - MooncatHelper

> Atomic buy-and-wrap contract to transform mooncats for sale
> in the adoption center into Wrapped Mooncats
> in a single transaction [for a 0.01 ETH fee].

<!-- https://twitter.com/seeker_curious/status/1371986578654916609
 -->

Etherscan

- MooncatHelper, see contract address [`0x9aa3d159eb155305a11af921696576a3e195d24d`](https://etherscan.io/address/0x9aa3d159eb155305a11af921696576a3e195d24d#code)



### /mooncats-vote - MoonCatKeyVote

> Should the MoonCatRescue developers
> destroy their private key so that no future Genesis MoonCats can ever be
> released?  Yes / True or No / False
>
> Update:
>
> The vote is live - please vote!
>
> Any address that has interacted with either
> the MoonCatRescue contract (`0x60cd862c9c687a9de49aecdc3a99b74a4fc54ab6`) or
> the main Wrapped MoonCatsRescue contract (`0x7c40c393dc0f283f318791d746d894ddd3693572`)
> prior to Block 12047300 (Mar-16-2021 03:35:24 AM +UTC) will get one vote.
>
> Update:
>
> The community has spoken.
> With a final outcome of YES: 944 NO: 367,
> the devs will destroy their private key to the MoonCatRescue contract.
> The contract will be left as found. The remaining Genesis MoonCats
> will never be released and will continue to live happily on the moon.


Etherscan

- MoonCatKeyVote, see contract address [`0x1916F482BB9F3523a489791Ae3d6e052b362C777`](https://etherscan.io/address/0x1916F482BB9F3523a489791Ae3d6e052b362C777#code)

For more see [**/mooncats-vote »**](mooncats-vote)


> Ponderware is destroying the private key controlling the
> MoonCatRescue contract
> due to the outcome of the vote contract.
>
> This contract represents a public transfer of the
> official ponderware address. To ensure confirmation and get ponderware's new address,
> call the `whereIsPonderware` function.

- PonderwareTransferOfAuthority, see contract address [`0xa3843c6f47384e3ca951bd0207179f58d2179d3f`](https://etherscan.io/address/0xa3843c6f47384e3ca951bd0207179f58d2179d3f#code)




### /mooncats-hd  -  High-Definition (HD) Mooncats (HDMC)

>  Mooncats a little low-res [~24x24 pixels]? Now admire them in all their beauty.
> Each Mooncat owner (unwrapped & wrapped) can mint the
> [High-Definition] HD version of their cats.
>
>  Price to mint follows the bonding curve:
>
> - 0-999: 0.01 eth
> - 1000-4999: 0.05 eth
> - 5000-14999: 0.10 eth
> - 15000-24339: 0.20 eth


Etherscan

- HDMooncats (HDMC), see contract address [`0xd1b01ea07981a40907f6b8f472cc8f37066dfea7`](https://etherscan.io/address/0xd1b01ea07981a40907f6b8f472cc8f37066dfea7#code)


For more see [**/mooncats-hd »**](mooncats-hd)





## MarsCats  - MoonCats "Remake" on Binance (Ethereum) Smart Chain

> Wow. You guys are awesome!
> All [25 600¹] cats has been rescued [in 24 hours]!
>
> Private key to access MoonCatRescue contract has been burned.
> That means 160 genesis cats will be forgotten forever.
> But, what if you can release all of the genesis cats?
> Wonder how cute they will look like?
> Go find and rescue them on MarsCatRescue.

¹: Minus the 256 possible released genesis cats.


### /marscats - MarsCatRescue

Bscscan

- MarsCatResuce, see contract address [`0xd31bad66aefa525b808ee569a514f6345b0bea2d`](https://bscscan.com/address/0xd31bad66aefa525b808ee569a514f6345b0bea2d#code)


For more see [**/marscats »**](marscats)


