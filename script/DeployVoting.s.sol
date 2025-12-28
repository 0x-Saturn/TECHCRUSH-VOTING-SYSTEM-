// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/TechCrushVoteToken.sol";
import "../src/TechCrushElection.sol";

contract DeployVoting is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy token
        TechCrushVoteToken token = new TechCrushVoteToken();
        console.log("Token deployed at:", address(token));

        // Deploy election
        TechCrushElection election = new TechCrushElection();
        console.log("Election deployed at:", address(election));

        vm.stopBroadcast();
    }
}
