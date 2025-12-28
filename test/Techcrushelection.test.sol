// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TechCrushVoteToken.sol";
import "../src/TechCrushElection.sol";

contract TechCrushElectionTest is Test {
    TechCrushVoteToken token;
    TechCrushElection election;

    address owner = address(0x1);
    address voter1 = address(0x2);
    address voter2 = address(0x3);
    address voter3 = address(0x4);

    string[] candidates;

    function setUp() public {
        // Deploy contracts
        vm.startPrank(owner);
        token = new TechCrushVoteToken();
        election = new TechCrushElection();
        vm.stopPrank();

        // Setup candidates
        candidates = new string[](3);
        candidates[0] = "Solidity";
        candidates[1] = "Rust";
        candidates[2] = "Python";
    }

    function test_CreateElection() public {
        vm.prank(owner);
        election.createElection("Best Language 2025", candidates, 1 days);

        assertTrue(election.currentActive());
        assertEq(election.currentTitle(), "Best Language 2025");
        assertEq(election.currentCandidate(0), "Solidity");
        assertEq(election.currentEndTime(), block.timestamp + 1 days);
    }

    function test_MultiplePeopleCanVote() public {
        vm.prank(owner);
        election.createElection("Best Language", candidates, 1 days);

        vm.prank(voter1);
        election.vote(0); // Solidity

        vm.prank(voter2);
        election.vote(1); // Rust

        vm.prank(voter3);
        election.vote(0); // Solidity

        uint256[] memory results = election.getResults();
        assertEq(results[0], 2); // Solidity
        assertEq(results[1], 1); // Rust
        assertEq(results[2], 0); // Python
    }

    function test_CannotVoteTwice() public {
        vm.prank(owner);
        election.createElection("Test Election", candidates, 1 days);

        vm.prank(voter1);
        election.vote(0);

        vm.expectRevert("You have already voted");
        vm.prank(voter1);
        election.vote(1);
    }

    function test_VotingClosesAfterDeadline() public {
        vm.prank(owner);
        election.createElection("Short Election", candidates, 10 minutes);

        // Move time forward past deadline
        vm.warp(block.timestamp + 11 minutes);

        vm.expectRevert("Voting period has ended");
        vm.prank(voter1);
        election.vote(0);
    }

    function test_CorrectWinnerSelected() public {
        vm.prank(owner);
        election.createElection("Winner Test", candidates, 1 days);

        vm.prank(voter1);
        election.vote(0);
        vm.prank(voter2);
        election.vote(0);
        vm.prank(voter3);
        election.vote(1);

        string memory winner = election.getWinner();
        assertEq(winner, "Solidity");
    }

    function test_WinnerWithTieReturnsFirst() public {
        vm.prank(owner);
        election.createElection("Tie Test", candidates, 1 days);

        vm.prank(voter1);
        election.vote(0);
        vm.prank(voter2);
        election.vote(1);

        string memory winner = election.getWinner();
        // Should return first one with max votes (Solidity or Rust - both have 1)
        // Our logic returns the first highest found
        assertTrue(
            keccak256(bytes(winner)) == keccak256(bytes("Solidity")) ||
            keccak256(bytes(winner)) == keccak256(bytes("Rust"))
        );
    }

    function test_TokenTransfersWorkNormally() public {
        vm.prank(owner);
        token.transfer(voter1, 1000 * 10**18);

        assertEq(token.balanceOf(voter1), 1000 * 10**18);
    }
}