// File contracts/interfaces/IDoomCat.sol


pragma solidity ^0.8.0;

interface IDoomCat {
    function mint(address, uint256) external;
    function swapAndBurn(uint256) external;
}
