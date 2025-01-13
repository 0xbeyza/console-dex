import hardhat from "hardhat";
const { ethers } = hardhat;

import { expect } from "chai";

describe("Pool Contract", function () {
  let TokenA, TokenB, Pool, tokenA, tokenB, pool, owner, addr1;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();

    // Sahte ERC20 tokenlarını deploy et
    const ERC20Mock = await ethers.getContractFactory("ERC20Mock");
    tokenA = await ERC20Mock.deploy("TokenA", "TKA", ethers.utils.parseEther("1000"));
    tokenB = await ERC20Mock.deploy("TokenB", "TKB", ethers.utils.parseEther("1000"));

    await tokenA.deployed();
    await tokenB.deployed();

    // Pool kontratını deploy et
    const PoolContract = await ethers.getContractFactory("Pool");
    pool = await PoolContract.deploy(tokenA.address, tokenB.address);
    await pool.deployed();

    // Tokenları approve et
    await tokenA.connect(owner).approve(pool.address, ethers.utils.parseEther("500"));
    await tokenB.connect(owner).approve(pool.address, ethers.utils.parseEther("500"));
  });

  it("Should add liquidity correctly", async function () {
    await pool.addLiquidity(ethers.utils.parseEther("100"), ethers.utils.parseEther("100"));

    const balances = await pool.showBalances();
    expect(balances[0]).to.equal(ethers.utils.parseEther("100"));
    expect(balances[1]).to.equal(ethers.utils.parseEther("100"));
  });

  it("Should swap tokens correctly", async function () {
    await pool.addLiquidity(ethers.utils.parseEther("100"), ethers.utils.parseEther("100"));

    await tokenA.connect(owner).approve(pool.address, ethers.utils.parseEther("10"));
    await pool.swap(ethers.utils.parseEther("10"), true);

    const balances = await pool.showBalances();
    expect(balances[0]).to.equal(ethers.utils.parseEther("110")); // TokenA havuza eklendi
    expect(balances[1]).to.be.below(ethers.utils.parseEther("100")); // TokenB havuzdan çıktı
  });
});
