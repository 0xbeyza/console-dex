// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Pool 
{

    // Variables

            IERC20 public tokenA;
            IERC20 public tokenB;
            uint256 public totalSupply;
            uint256 public ratio;
            uint256 balanceA;
            uint256 balanceB;
            
            uint256 constantProduct;
            

    mapping(address => userBalance) public balances;

    // Constructor

            constructor(address _token0, address _token1) 
            {
                tokenA = IERC20(_token0);
                tokenB = IERC20(_token1);
                tokenA.approve(address(this), 100);
                tokenB.approve(address(this), 100);
                tokenA.transferFrom(msg.sender, address(this), 100);
                tokenB.transferFrom(msg.sender, address(this), 100);

                constantProduct = tokenA.balanceOf(address(this))*tokenB.balanceOf(address(this));
            }

    // 1. Add Liquidity

                 //  Add Liquidity for tokenA
                function addLiquidityA(uint256 amount) public 
                { 
                    ratio = tokenB.balanceOf(address(this))/tokenA.balanceOf(address(this));
                
                    require(amount > 0, "Amount must be greater than 0");
                    require(tokenB.balanceOf(msg.sender) >= amount*ratio, "For this amount of tokenA, you do not have enough tokenB");
                
                    tokenA.approve(address(this), amount);              // Burada approve edilen token kontratın mı yoksa çağıran kişiye mi ait 
                    tokenB.approve(address(this), amount*ratio);   
                    
                    balanceA += amount;
                    balanceB += amount*ratio;

                    tokenA.transferFrom(msg.sender, address(this), amount);   
                    tokenB.transferFrom(msg.sender,address(this), amount*ratio);

                    constantProduct = tokenA.balanceOf(address(this))*tokenB.balanceOf(address(this));
                }
                
                // Add Liquidity for tokenB
                function addLiquidityB(uint256 amount) public 
                { 
                    ratio = tokenA.balanceOf(address(this))/tokenB.balanceOf(address(this));
                
                    require(amount > 0, "Amount must be greater than 0");
                    require(tokenA.balanceOf(msg.sender) >= amount*ratio, "For this amount of tokenB, the pool does not have enough tokenA");
                
                    tokenB.approve(address(this), amount);              // Burada approve edilen token kontratın mı yoksa çağıran kişiye mi ait 
                    tokenA.approve(address(this), amount*ratio);   

                    balanceB += amount;
                    balanceA += amount*ratio;

                    tokenB.transferFrom(msg.sender, address(this), amount);   
                    tokenA.transferFrom(msg.sender,address(this), amount*ratio);

                    constantProduct = tokenA.balanceOf(address(this))*tokenB.balanceOf(address(this));
                }

    // 2. Remove Liqudity

                // Remove Liquidity for tokenA
                
                function removeLiquidity(uint256 amount) public 
                {
                    ratio = tokenA.balanceOf(address(this))/tokenB.balanceOf(address(this));

                    require(balanceA >= amount && balanceB >= amount*ratio, "You dont need have enough likidite for removing");
                    require(amount < tokenA.balanceOf(addres(this)), "Amount must be lower than pool balance");
                    require(amount*ratio < tokenB.balanceOf(addres(this)), "For this amount of tokenA, the pool does not have enough tokenB");

                    tokenA.approve(address(this), amount);             // Burada approve edilen token kontratın mı yoksa çağıran kişiye mi ait 
                    tokenB.approve(address(this), amount*ratio);

                    balanceA -= amount;
                    balanceB -= amount*ratio;

                    tokenA.transferFrom(address(this), msg.sender, amount);
                    tokenB.transferFrom(address(this), msg.sender, amount*ratio);

                    constantProduct = tokenA.balanceOf(address(this))*tokenB.balanceOf(address(this));
                }

                // Remove Liquidity for tokenB

                function removeLiquidity(uint256 amount) public 
                {
                    ratio = tokenB.balanceOf(address(this))/tokenA.balanceOf(address(this));

                    require(balanceB >= amount && balanceA >= amount*ratio, "You dont need have enough likidite for removing");
                    require(amount < tokenB.balanceOf(addres(this)), "Amount must be lower than pool balance");
                    require(amount*ratio < tokenA.balanceOf(addres(this)), "For this amount of tokenB, the pool does not have enough tokenA");

                    tokenB.approve(address(this), amount);             // Burada approve edilen token kontratın mı yoksa çağıran kişiye mi ait 
                    tokenA.approve(address(this), amount*ratio);

                    balanceB -= amount;
                    balanceA -= amount*ratio;

                    tokenB.transferFrom(address(this), msg.sender, amount);
                    tokenA.transferFrom(address(this), msg.sender, amount*ratio);

                    constantProduct = tokenA.balanceOf(address(this))*tokenB.balanceOf(address(this));
                }

    // 3. Swap Tokens

                function swap(uint256 amountIn, bool swapTokenAForTokenB) public 
                {
                    if(swapTokenAForTokenB)
                    {
                        require(amountIn < tokenA.balanceOf(address(this)), "Amount must be lower than pool balance");

                        tokenA.approve(address(this), amountIn);

                        tokenA.transferFrom(address(this), msg.sender, amountIn);
                        tokenB.transferFrom(msg.sender, address(this), amountIn*ratio);
                    }
                    else
                    {
                        require(amountIn < tokenB.balanceOf(address(this)), "Amount must be lower than pool balance");

                        tokenB.approve(address(this), amountIn);

                        tokenB.transferFrom(address(this), msg.sender, amountIn);
                        tokenA.transferFrom(msg.sender, address(this), amountIn*ratio);
                    }
                }

    // 4. Show Balance

                function showBalance() public view returns (uint256 ,uint256 ,uint256 ,uint256)
                {
                    return (tokenA.balanceOf(address(this)), tokenB.balanceOf(address(this)) , balanceA, balanceB);
                }
}