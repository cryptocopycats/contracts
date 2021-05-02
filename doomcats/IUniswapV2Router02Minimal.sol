// File contracts/interfaces/IUniswapV2Router02Minimal.sol


pragma solidity ^0.8.0;

interface IUniswapV2Router02Minimal {
    function WETH() external pure returns (address);
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;
}

