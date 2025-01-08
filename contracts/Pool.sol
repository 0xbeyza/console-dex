// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Pool {
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public totalSupply;
   
    
    struct userBalance{
        uint256 balance0;
        uint256 balance1;
    }

    mapping(address => userBalance) public balances;
    uint256 public ratio;
    // Constructor
    constructor(address _token0, address _token1) {
        tokenA = IERC20(_token0);
        tokenB = IERC20(_token1);
        tokenA.approve(address(this), 100);
        tokenB.approve(address(this), 100);
        tokenA.transferFrom(msg.sender, address(this), 100);
        tokenB.transferFrom(msg.sender, address(this), 100);
        
    }

    // 1. Add Liquidity
    function addLiquidityA(uint256 amount) public { 

       ratio = tokenB.balanceOf(address(this))/tokenA.balanceOf(address(this));
       
       require(amount > 0, "Amount must be greater than 0");
       require(tokenB.balanceOf(msg.sender) >= amount*ratio, "Insufficient balance for tokenB");
       
       tokenA.approve(address(this), amount);
       tokenB.approve(address(this), amount*ratio);   

       tokenA.transferFrom(msg.sender, address(this), amount);   
       tokenB.transferFrom(msg.sender,address(this), amount*ratio);
    
    }

    // 2. Remove Liquidity
    function removeLiquidity(uint256 amount0, uint256 amount1) public {
       
    }

    // 3. Swap Tokens
    function swap(uint256 amountIn, bool swapToken0ForToken1) public {
       
    }

    // 4. Show Balance
    function showBalance() public view returns (uint256 balance0, uint256 balance1) {
       
    }
}