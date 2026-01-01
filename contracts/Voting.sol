// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    struct Election {
        string title;
        string[] candidates;
        uint256 endTime;
        bool active;
    }

    Election public election;
    mapping(address => bool) public voted;
    mapping(uint256 => uint256) public votes; // candidateIndex => voteCount

    constructor() Ownable(msg.sender) {}

    function createElection(
        string memory _title,
        string[] memory _candidates,
        uint256 _duration
    ) public onlyOwner {
        election = Election(_title, _candidates, block.timestamp + _duration, true);
    }

    function vote(uint256 _candidateIndex) public {
        require(election.active, "Election is not active");
        require(block.timestamp < election.endTime, "Voting has ended");
        require(!voted[msg.sender], "Already voted");
        require(_candidateIndex < election.candidates.length, "Invalid candidate index");
        votes[_candidateIndex]++;
        voted[msg.sender] = true;
    }

    function getResults() public view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](election.candidates.length);
        for (uint256 i = 0; i < election.candidates.length; i++) {
            result[i] = votes[i];
        }
        return result;
    }

    function getWinner() public view returns (string memory) {
        uint256 maxVotes = 0;
        uint256 winnerIndex = 0;
        for (uint256 i = 0; i < election.candidates.length; i++) {
            if (votes[i] > maxVotes) {
                maxVotes = votes[i];
                winnerIndex = i;
            }
        }
        return election.candidates[winnerIndex];
    }

    function hasVoted(address _voter) public view returns (bool) {
        return voted[_voter];
    }
}