//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "./Pool.sol";

contract PoolFactory {
    address[] public pools;

    function createPool(address token0, address token1, uint256 ratio) public {
        Pool newPool = new Pool(token0, token1,ratio);
        pools.push(address(newPool));
    }
}