# Example Anvil run — "Best Programming Language 2025"

This documents a local Anvil run that demonstrates the full scenario required in the checklist.

Summary
-------
- Election title: "Best Programming Language 2025"
- Candidates: ["Solidity", "Rust", "Python"]
- Duration: 1 day (86400 seconds)

Votes cast
----------
- Voter1 (Anvil account 1) voted for Solidity (index 0)
- Voter2 (Anvil account 2) voted for Rust (index 1)
- Voter3 (Anvil account 3) voted for Solidity (index 0)

Observed results
----------------
- getResults(): [2, 1, 0]
- getWinner(): "Solidity"

Transaction examples (from local Anvil run)
-----------------------------------------
- Token deploy (CREATE): 0x4053cd90e866e27d71bd7700fc62a62616c30551df1ae24f7360915ae530150c
- Election deploy (CREATE): 0x6029cffccf4a2fe2e7ecc4e290ebc8c548c866bdc4a94858a0dd76a159d11b2c
- createElection (CALL): 0xd970d3fd60736ebf896b7a38199acde964a34a8d9ce8036f1bfcc5da1734e44e
- Vote (Voter1 -> Solidity): 0x67c88ba49ee73450941e116aba89f373b531c5f64af5604d6633651b7fc4c6d4
- Vote (Voter2 -> Rust): 0xef540a0ae9f9d50e25e729976bc166f7aca6c313573ad00e6cfe00c728c203c1
- Vote (Voter3 -> Solidity): 0x18ded1837365594735469b1c9c75ce6ad57ecdf176e408a512c92f789619250f

Notes
-----
- A script located at `script/RunElection.s.sol` reproduces this scenario (uses Anvil default test private keys).
- The broadcast JSON for the run is saved at `broadcast/RunElection.s.sol/31337/run-latest.json` (contains transactions and receipts per the session).
- The tests in `test/Techcrushelection.test.sol` already cover the checklist and pass locally.

Checklist
---------
- [x] Can create an election (createElection)
- [x] Multiple people can vote (vote)
- [x] Cannot vote twice (reverts) — covered in tests
- [x] Voting closes after deadline (reverts) — covered in tests
- [x] Correct winner selected (getWinner)

If you want, I can add a CI job that runs `script/RunElection.s.sol` against a live testnet (requires funded testnet account + RPC + secrets) and saves the `run-latest.json` as an artifact.
