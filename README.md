# TECHCRUSH-VOTING-SYSTEM-

This is our capstone project for TECHCRUSH Smart Contract Development. It includes an ERC-20 token and a voting contract for transparent elections.

## Contracts

### TechCrushToken
- **Name**: TechCrush Airdrop Token
- **Symbol**: TCT
- **Total Supply**: 1,000,000 TCT
- **Decimals**: 18

### Voting
A contract for creating elections and voting.

#### Functions
- `createElection(string title, string[] candidates, uint256 duration)` - Only owner can create an election.
- `vote(uint256 candidateIndex)` - Vote for a candidate.
- `getResults()` - Get vote counts for each candidate.
- `getWinner()` - Get the winning candidate.
- `hasVoted(address voter)` - Check if an address has voted.

## Testing Checklist
- [x] Can I create an election?
- [x] Can multiple people vote?
- [x] Can I vote twice? (Should fail!)
- [x] Does voting close after deadline?
- [x] Does the right winner get selected?

## How to Run
1. Install dependencies: `npm install`
2. Compile: `npx hardhat compile`
3. Test: `npx hardhat test`
4. Deploy: `npx hardhat run scripts/deploy.js`

## Deployed Contract Addresses (Update with actual)
- TechCrushToken: [Address]
- Voting: [Address]

## Explanation of Elections and Results
For demonstration, we created an election "Best Programming Language" with candidates ["Solidity", "Rust", "CSS"].
After voting, Solidity won with the most votes.
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



