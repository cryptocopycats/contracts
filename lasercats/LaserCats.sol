// SPDX-License-Identifier: MIT

pragma solidity ^ 0.8.0;

import "./SafeMath.sol";
import "./Context.sol";
import "./Ownable.sol";
import "./Strings.sol";
import "./Address.sol";
import "./IERC165.sol";
import "./ERC165.sol";
import "./IERC721.sol";
import "./IERC721Enumerable.sol";
import "./IERC721Metadata.sol";
import "./IERC721Receiver.sol";



contract LaserCats is ERC721Enumerable, Ownable {
  using SafeMath for uint256;
  uint public constant maxTokenSupply = 25440;
  uint public presalePriceCap;
  uint public startPrice;
  uint public priceFactor;
  uint public maxTxQty;
  bool public mintingAllowed;

  constructor() ERC721("LaserCats", "LaserCats") { }

  function getTokensOfOwner(address _owner) external view returns(uint256[] memory) {
    uint256 tokenCount = balanceOf(_owner);
    if (tokenCount == 0) {
      return new uint256[](0);
    } else {
      uint256[] memory result = new uint256[](tokenCount);
      uint256 index;
      for (index = 0; index < tokenCount; index++) {
        result[index] = tokenOfOwnerByIndex(_owner, index);
      }
      return result;
    }
  }

  function getPresaleQty() public view returns(uint256) {
    require(mintingAllowed == true, "Minting not allowed yet.");
    require(totalSupply() < maxTokenSupply, "All tokens have been minted.");
    return maxTxQty;
  }

  function getPresalePrice() public view returns(uint256) {
    require(mintingAllowed == true, "Minting not allowed yet.");
    require(totalSupply() < maxTokenSupply, "All tokens have been minted.");
    return startPrice.mul(10 ** 16) + totalSupply().div(100).mul(priceFactor);
  }

  function mintToken(uint256 qty) public payable {
    require(qty > 0 && qty <= getPresaleQty(), "Quantity exceeds allowed.");
    require(totalSupply().add(qty) <= maxTokenSupply, "Quantity exceeds max supply.");
    require(msg.value >= getPresalePrice().mul(qty), "Ether value to send is insufficient.");

    for (uint i = 0; i < qty; i++) {
      uint mintIndex = totalSupply();
      _safeMint(msg.sender, mintIndex);
    }
  }

  // reserves tokens 0-99 for giveaways
  function mintPromoToken(uint256 qty) public onlyOwner {
    require(totalSupply().add(qty) <= 100, "Quantity exceeds allowed.");

    for (uint i = 0; i < qty; i++) {
      uint mintIndex = totalSupply();
      _safeMint(msg.sender, mintIndex);
    }
  }

  function setPresaleAmounts(uint start, uint cap, uint qty) public onlyOwner {
    startPrice = start;
    presalePriceCap = cap;
    maxTxQty = qty;
    priceFactor = ((cap - start) * (10 ** 5) / (maxTokenSupply.div(100))) * (10 ** 11);
  }

  function setBaseURI(string memory baseURI) public onlyOwner {
    _setBaseURI(baseURI);
  }

  function beginPresale() public onlyOwner {
    mintingAllowed = true;
  }

  function pausePresale() public onlyOwner {
    mintingAllowed = false;
  }

  function withdraw() public payable onlyOwner {
    require(payable(msg.sender).send(address(this).balance));
  }
}