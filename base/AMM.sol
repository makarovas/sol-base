// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract AdvancedAMM {
    address public token0;
    address public token1;
    uint private reserve0;
    uint private reserve1;
    uint public feePercent; // Dynamic fee percentage

    constructor(address _token0, address _token1, uint _feePercent) {
        token0 = _token0;
        token1 = _token1;
        feePercent = _feePercent;
    }

    function updateFee(uint _newFee) external {
        feePercent = _newFee;
        // access control mechanism here

    }

    function addLiquidity(uint _amount0, uint _amount1) external {
        IERC20(token0).transferFrom(msg.sender, address(this), _amount0);
        IERC20(token1).transferFrom(msg.sender, address(this), _amount1);
        reserve0 += _amount0;
        reserve1 += _amount1;
        // Liquidity tokens minting here
    }

    function swap(uint _amountIn, address _tokenIn, address _tokenOut) external {
        require(_tokenIn == token0 || _tokenIn == token1, "Invalid token");
        require(_tokenOut == token0 || _tokenOut == token1, "Invalid token");
        require(_tokenIn != _tokenOut, "Invalid swap");

        (uint inputReserve, uint outputReserve) = _tokenIn == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
        uint fee = _amountIn * feePercent / 10000;
        uint amountInWithFee = _amountIn - fee;
        uint amountOut = (amountInWithFee * outputReserve) / (inputReserve + amountInWithFee);

        // Transfer logic here
        //  reserves logic here
    }

    // Additional removing liquidity
}
