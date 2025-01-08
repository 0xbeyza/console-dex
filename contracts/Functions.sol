// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Pool {
    address public token0;
    address public token1;
    uint256 public totalSupply;

    mapping(address => uint256) public balances0;  // token0 bakiyesi
    mapping(address => uint256) public balances1;  // token1 bakiyesi

    // Constructor
    constructor(address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
        totalSupply = 0;
    }

    // 1. Add Liquidity
    function addLiquidity(uint256 amount0, uint256 amount1) public {
        require(IERC20(token0).transferFrom(msg.sender, address(this), amount0), "Transfer basarisiz");
        require(IERC20(token1).transferFrom(msg.sender, address(this), amount1), "Transfer basarisiz");
        
        balances0[msg.sender] += amount0;
        balances1[msg.sender] += amount1;
        totalSupply += amount0 + amount1;
    }

    // 2. Remove Liquidity
    function removeLiquidity(uint256 amount0, uint256 amount1) public {
        require(balances0[msg.sender] >= amount0, "Insufficient balance for token0");
        require(balances1[msg.sender] >= amount1, "Insufficient balance for token1");
        
        balances0[msg.sender] -= amount0;
        balances1[msg.sender] -= amount1;
        totalSupply -= amount0 + amount1;

        require(IERC20(token0).transfer(msg.sender, amount0), "Transfer failed");
        require(IERC20(token1).transfer(msg.sender, amount1), "Transfer failed");
    }

    // 3. Swap Tokens
    function swap(uint256 amountIn, bool swapToken0ForToken1) public {
        uint256 amountOut;
        if (swapToken0ForToken1) {
            // Token0'dan Token1'e swap
            require(IERC20(token0).transferFrom(msg.sender, address(this), amountIn), "Transfer failed");
            amountOut = amountIn * 2;  // Basit takas oranı
            require(IERC20(token1).transfer(msg.sender, amountOut), "Transfer failed");
        } else {
            // Token1'den Token0'a swap
            require(IERC20(token1).transferFrom(msg.sender, address(this), amountIn), "Transfer failed");
            amountOut = amountIn / 2;  // Basit takas oranı
            require(IERC20(token0).transfer(msg.sender, amountOut), "Transfer failed");
        }
    }

    // 4. Show Balance
    function showBalance() public view returns (uint256 balance0, uint256 balance1) {
        balance0 = balances0[msg.sender];
        balance1 = balances1[msg.sender];
    }
}