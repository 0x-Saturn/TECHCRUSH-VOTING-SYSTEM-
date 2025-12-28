// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TechCrushElection is Ownable {
    struct Election {
        string title;
        string[] candidates;
        uint256 endTime;
        bool active;
    }

    Election public currentElection;

    // voteCounts[i] = number of votes for candidates[i]
    uint256[] public voteCounts;

    // Track who has voted (one vote per address per election)
    mapping(address => bool) public hasVoted;

    event ElectionCreated(string title, uint256 endTime);
    event VoteCast(address indexed voter, uint256 candidateIndex);
    event ElectionEnded();

    constructor() Ownable(msg.sender) {}

    /**
     * @dev Create a new election - only owner
     * @param _title Election title
     * @param _candidates Array of candidate names
     * @param _durationSeconds How long voting lasts (in seconds)
     */
    function createElection(
        string memory _title,
        string[] memory _candidates,
        uint256 _durationSeconds
    ) external onlyOwner {
        require(_candidates.length > 0, "At least one candidate required");
        require(_durationSeconds > 0, "Duration must be positive");

        currentElection = Election({
            title: _title,
            candidates: _candidates,
            endTime: block.timestamp + _durationSeconds,
            active: true
        });

        // Reset vote counts
        delete voteCounts;
        voteCounts = new uint256[](_candidates.length);

        // Note: We don't reset hasVoted mapping (it's per-election by design here)
        // If we want multiple elections without overlap, we can add electionId later

        emit ElectionCreated(_title, currentElection.endTime);
    }

    /**
     * @dev Cast a vote
     * @param candidateIndex Index of chosen candidate
     */
    function vote(uint256 candidateIndex) external {
        require(currentElection.active, "No active election");
        require(block.timestamp < currentElection.endTime, "Voting period has ended");
        require(candidateIndex < currentElection.candidates.length, "Invalid candidate index");
        require(!hasVoted[msg.sender], "You have already voted");

        voteCounts[candidateIndex]++;
        hasVoted[msg.sender] = true;

        emit VoteCast(msg.sender, candidateIndex);
    }

    /**
     * @dev Get current vote counts
     */
    function getResults() external view returns (uint256[] memory) {
        return voteCounts;
    }

    /**
     * @dev Get winner (first one if tie)
     */
    function getWinner() external view returns (string memory winner) {
        require(voteCounts.length > 0, "No election created yet");

        uint256 winningVoteCount = 0;
        uint256 winningIndex = 0;

        for (uint256 i = 0; i < voteCounts.length; i++) {
            if (voteCounts[i] > winningVoteCount) {
                winningVoteCount = voteCounts[i];
                winningIndex = i;
            }
        }

        return currentElection.candidates[winningIndex];
    }

    /**
     * @dev Helper view functions for the current election
     */
    function currentActive() external view returns (bool) {
        return currentElection.active;
    }

    function currentTitle() external view returns (string memory) {
        return currentElection.title;
    }

    function currentCandidate(uint256 index) external view returns (string memory) {
        return currentElection.candidates[index];
    }

    function currentEndTime() external view returns (uint256) {
        return currentElection.endTime;
    }

    /**
     * @dev Manually end election early (optional, useful for testing)
     */
    function endElection() external onlyOwner {
        currentElection.active = false;
        emit ElectionEnded();
    }
}