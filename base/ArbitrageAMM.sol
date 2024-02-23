// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ArbitrageAMM {
    address public uniswapRouter;
    address public tokenA;
    address public tokenB;

    constructor(address _uniswapRouter, address _tokenA, address _tokenB) {
        uniswapRouter = _uniswapRouter;
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function startArbitrage(uint amountIn) external {
        address[] memory path = new address[](2);
        path[0] = tokenA;
        path[1] = tokenB;

        uint[] memory amounts = IUniswapV2Router02(uniswapRouter).getAmountsOut(amountIn, path);
        uint amountOutMin = amounts[1];

        IERC20(tokenA).approve(uniswapRouter, amountIn);
        IUniswapV2Router02(uniswapRouter).swapExactTokensForTokens(amountIn, amountOutMin, path, address(this), block.timestamp);
    }
}