const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Voting", function () {
  let Voting, voting, owner, addr1, addr2;

  beforeEach(async function () {
    Voting = await ethers.getContractFactory("Voting");
    [owner, addr1, addr2] = await ethers.getSigners();
    voting = await Voting.deploy();
    await voting.deployed();
  });

  it("Should create an election", async function () {
    const candidates = ["Solidity", "Rust", "CSS"];
    await voting.createElection("Best Language", candidates, 3600);
    const election = await voting.election();
    expect(election.title).to.equal("Best Language");
    // expect(election.candidates).to.have.lengthOf(3);
  });

  it("Should allow voting", async function () {
    const candidates = ["Solidity", "Rust"];
    await voting.createElection("Best Language", candidates, 3600);
    await voting.connect(addr1).vote(0);
    const results = await voting.getResults();
    expect(results[0]).to.equal(1);
  });

  it("Should not allow voting twice", async function () {
    const candidates = ["Solidity", "Rust"];
    await voting.createElection("Best Language", candidates, 3600);
    await voting.connect(addr1).vote(0);
    await expect(voting.connect(addr1).vote(1)).to.be.revertedWith("Already voted");
  });

  it("Should not allow voting after end time", async function () {
    const candidates = ["Solidity", "Rust"];
    await voting.createElection("Best Language", candidates, 1);
    await ethers.provider.send("evm_increaseTime", [2]);
    await expect(voting.connect(addr1).vote(0)).to.be.revertedWith("Voting has ended");
  });

  it("Should get the winner", async function () {
    const candidates = ["Solidity", "Rust"];
    await voting.createElection("Best Language", candidates, 3600);
    await voting.connect(addr1).vote(0);
    await voting.connect(addr2).vote(1);
    await voting.connect(owner).vote(0);
    const winner = await voting.getWinner();
    expect(winner).to.equal("Solidity");
  });
});