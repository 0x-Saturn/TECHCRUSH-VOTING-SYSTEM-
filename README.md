# TECHCRUSH-VOTING-SYSTEM-


This is our capstone project for TECHCRUSH Smart Contract Development. It includes an ERC-20 token and a voting contract for transparent elections.

## Deployed Contract Addresses (Anvil)
- TechCrushVoteToken: 0x5FbDB2315678afecb367f032d93F642f64180aa3 (example; we will replace with ours)
- TechCrushElection: 0xe7f1725E324598e5b5aF3f6f6f6f6f6f6f6f6f6f (example; we will replace with ours)

## Explanation of Elections and Results
We created an election titled "Best Programming Language 2025" with candidates ["Solidity", "Rust", "Python"] and duration 1 day.

- Voter1 voted for Solidity (index 0)
- Voter2 voted for Rust (index 1)
- Voter3 voted for Solidity (index 0)

Results from getResults(): [2, 1, 0]  
Winner from getWinner(): "Solidity"

Transaction examples:
- Election creation tx hash: 0x... (from Anvil logs)
- Vote tx hash: 0x... (from Anvil logs)

All testing checklist items passed:
- [x] Can create an election
- [x] Multiple people can vote
- [x] Cannot vote twice (reverts)
- [x] Voting closes after deadline (reverts)
- [x] Correct winner selected

Built with Foundry.



