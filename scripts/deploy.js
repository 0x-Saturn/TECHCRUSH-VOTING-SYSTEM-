const { ethers } = require("hardhat");

async function main() {
  // Deploy Token
  const Token = await ethers.getContractFactory("TechCrushToken");
  const token = await Token.deploy();
  await token.deployed();
  console.log("Token deployed to:", token.address);

  // Deploy Voting
  const Voting = await ethers.getContractFactory("Voting");
  const voting = await Voting.deploy();
  await voting.deployed();
  console.log("Voting deployed to:", voting.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });