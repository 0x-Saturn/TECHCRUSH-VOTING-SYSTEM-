// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/TechCrushVoteToken.sol";
import "../src/TechCrushElection.sol";

contract RunElection is Script {
    // Anvil default private keys (public test fixtures)
    uint256 constant DEPLOYER_PK = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 constant VOTER1_PK = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;
    uint256 constant VOTER2_PK = 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a;
    uint256 constant VOTER3_PK = 0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6;

    function run() external {
        // Deploy token and election as DEPLOYER
        vm.startBroadcast(DEPLOYER_PK);
        TechCrushVoteToken token = new TechCrushVoteToken();
        TechCrushElection election = new TechCrushElection();

        // Setup candidates
        string[] memory candidates = new string[](3);
        candidates[0] = "Solidity";
        candidates[1] = "Rust";
        candidates[2] = "Python";

        election.createElection("Best Programming Language 2025", candidates, 1 days);

        console.log("Election created by:", msg.sender);
        vm.stopBroadcast();

        // Cast votes from different voters
        vm.startBroadcast(VOTER1_PK);
        election.vote(0); // Solidity
        vm.stopBroadcast();

        vm.startBroadcast(VOTER2_PK);
        election.vote(1); // Rust
        vm.stopBroadcast();

        vm.startBroadcast(VOTER3_PK);
        election.vote(0); // Solidity
        vm.stopBroadcast();

        // Read results without broadcasting
        uint256[] memory results = election.getResults();
        console.log("Results:", results[0], results[1], results[2]);
        string memory winner = election.getWinner();
        console.log("Winner:", winner);

        // Print addresses for reference
        console.log("Token address:", address(token));
        console.log("Election address:", address(election));
    }
}
