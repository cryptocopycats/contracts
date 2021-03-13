# Inside the MoonCatRescue Blockchain Contract / Service


## Source Code

MoonCatRescue @ Etherscan, see contract address [`0x60cd862c9c687a9de49aecdc3a99b74a4fc54ab6`](https://etherscan.io/address/0x60cd862c9c687a9de49aecdc3a99b74a4fc54ab6#code)

Contracts & More @
GitHub, see [MoonCatRescue-Contract @ ponderware](https://github.com/ponderware/MoonCatRescue-Contract)




### MoonCatRescue

#### Constants

Use this to verify mooncatparser.js the cat image data generation javascript file

``` solidity
bytes16 public imageGenerationCodeMD5 = 0xdbad5c08ec98bec48490e3c196eec683;
```

MoonCats meta data:

```
string public name = "MoonCats";
string public symbol = "?"; // unicode cat symbol
uint8 public decimals = 0;

uint256 public totalSupply = 25600;
uint16 public remainingCats = 25600 - 256; // there will only ever be 25,000 cats
uint16 public remainingGenesisCats = 256; // there can only be a maximum of 256 genesis cats
```

Gets set with the immediately preceding blockhash when the contract is activated to prevent "premining"

```
bytes32 public searchSeed = 0x0;
```




#### Events

**CatRescued**

``` solidity
event CatRescued(address indexed to, bytes5 indexed catId);
```

**CatNamed**

``` solidity
event CatNamed(bytes5 indexed catId, bytes32 catName);
```

**CatAdopted**

``` solidity
event CatAdopted(bytes5 indexed catId, uint price, address indexed from, address indexed to);
```

**AdoptionOffered / AdoptionOfferCancelled**

``` solidity
event AdoptionOffered(bytes5 indexed catId, uint price, address indexed toAddress);
event AdoptionOfferCancelled(bytes5 indexed catId);
```

**AdoptionRequested / AdoptionRequestCancelled**

``` solidity
event AdoptionRequested(bytes5 indexed catId, uint price, address indexed from);
event AdoptionRequestCancelled(bytes5 indexed catId);
```

**GenesisCatsAdded**

``` solidity
event GenesisCatsAdded(bytes5[16] catIds);
```

**Transfer**

``` solidity
event Transfer(address indexed from, address indexed to, uint256 value);
```


#### Structs

**AdoptionOffer**

``` solidity
  struct AdoptionOffer {
    bool exists;
    bytes5 catId;
    address seller;
    uint price;
    address onlyOfferTo;
  }
```

**AdoptionRequest**

``` solidity
  struct AdoptionRequest {
    bool exists;
    bytes5 catId;
    address requester;
    uint price;
  }
```

#### Storage

**adoptionOffers**

``` solidity
mapping (bytes5 => AdoptionOffer) public adoptionOffers;
```

**adoptionRequests**

``` solidity
mapping (bytes5 => AdoptionRequest) public adoptionRequests;
```

**catNames**

``` solidity
  mapping (bytes5 => bytes32) public catNames;
```

**catOwners**

``` solidity
  mapping (bytes5 => address) public catOwners;
```

**balanceOf**

number of cats owned by a given address
``` solidity
  mapping (address => uint256) public balanceOf;
```

**pendingWithdrawals**

``` solidity
  mapping (address => uint) public pendingWithdrawals;
```



#### Functions

**rescueCat  (Historic)**

registers and validates cats that are found

``` solidity
  function rescueCat(bytes32 seed) returns (bytes5)
```

**nameCat**

assigns a name to a cat, once a name is assigned it cannot be changed

note: ensure the current name is empty; cats can only be named once

note: cats cannot be named while they are up for adoption

``` solidity
  function nameCat(bytes5 catId, bytes32 catName)
```

**makeAdoptionOffer**

puts a cat up for anyone to adopt

``` solidity
  function makeAdoptionOffer(bytes5 catId, uint price)
```

**makeAdoptionOfferToAddress**

puts a cat up for a specific address to adopt

``` solidity
  function makeAdoptionOfferToAddress(bytes5 catId, uint price, address to)
```

**cancelAdoptionOffer**

cancel an adoption offer

``` solidity
  function cancelAdoptionOffer(bytes5 catId)
```

**acceptAdoptionOffer**

accepts an adoption offer

``` solidity
  function acceptAdoptionOffer(bytes5 catId) payable
```

**giveCat**

transfer a cat directly without payment

``` solidity
  function giveCat(bytes5 catId, address to)
```

**makeAdoptionRequest**

requests adoption of a cat with an ETH offer

``` solidity
function makeAdoptionRequest(bytes5 catId) payable
```

**acceptAdoptionRequest**

allows the owner of the cat to accept an adoption request

``` solidity
function acceptAdoptionRequest(bytes5 catId)
```

**cancelAdoptionRequest**

allows the requester to cancel their adoption request

``` solidity
function cancelAdoptionRequest(bytes5 catId)
```

**withdraw**

``` solidity
function withdraw()
```



#####  Owner only functions

**addGenesisCatGroup**

add genesis cats in groups of 16

``` solidity
function addGenesisCatGroup()
```

#####  Aggregate getters

**getCatIds**

``` solidity
  function getCatIds() constant returns (bytes5[]) {
```

**getCatNames**

``` solidity
  function getCatNames() constant returns (bytes32[]) {
```

**getCatOwners**

``` solidity
  function getCatOwners() constant returns (address[]) {
```

**getCatOfferPrices**

``` solidity
  function getCatOfferPrices() constant returns (uint[]) {
```

**getCatRequestPrices**

``` solidity
  function getCatRequestPrices() constant returns (uint[]) {
```

**getCatDetails**

``` solidity
  function getCatDetails(bytes5 catId) constant returns (bytes5 id,
                                                         address owner,
                                                         bytes32 name,
                                                         address onlyOfferTo,
                                                         uint offerPrice,
                                                         address requester,
                                                         uint requestPrice)
```
