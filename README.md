## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
# Local (Anvil) dry-run
$ anvil --silent &
$ forge script script/DeployVoting.s.sol:DeployVoting -vvvv

# Broadcast to local Anvil (use the Anvil-private key shown when running Anvil)
$ forge script script/DeployVoting.s.sol:DeployVoting --broadcast --private-key <ANVIL_PRIVATE_KEY> --rpc-url http://127.0.0.1:8545 -vvvv

# Broadcast to a public testnet (example: Sepolia)
$ export RPC_URL="https://eth-sepolia.g.alchemy.com/v2/<KEY>"
$ export FORGE_PRIVATE_KEY="<YOUR_DEPLOYER_PRIVATE_KEY>"
$ forge script script/DeployVoting.s.sol:DeployVoting --broadcast --private-key $FORGE_PRIVATE_KEY --rpc-url $RPC_URL -vvvv

# Verification (Etherscan). Requires an Etherscan API key.
# Example (Sepolia):
# 1) Deploy and copy the contract address from output
# 2) Run verification:
$ forge verify-contract --chain-id 11155111 <CONTRACT_ADDRESS> src/TechCrushVoteToken.sol:TechCrushVoteToken --etherscan-api-key <ETHERSCAN_KEY>
$ forge verify-contract --chain-id 11155111 <CONTRACT_ADDRESS> src/TechCrushElection.sol:TechCrushElection --etherscan-api-key <ETHERSCAN_KEY>

# Example Anvil run
See `docs/example_anvil_run.md` for a recorded local Anvil scenario (includes transaction hashes, results and winner) that reproduces the requested scenario: "Best Programming Language 2025" with votes from three voters and results [2,1,0], winner "Solidity".

# Verification examples for common chains (step-by-step)

## Sepolia (Ethereum testnet)
# Chain ID: 11155111
# Steps (after deploy):
# 1) Get contract addresses from the deploy output or CI artifact `deployed_addresses.env`.
# 2) Verify the token contract:
$ forge verify-contract --chain-id 11155111 <TOKEN_ADDRESS> src/TechCrushVoteToken.sol:TechCrushVoteToken --etherscan-api-key <ETHERSCAN_KEY>
# 3) Verify the election contract:
$ forge verify-contract --chain-id 11155111 <ELECTION_ADDRESS> src/TechCrushElection.sol:TechCrushElection --etherscan-api-key <ETHERSCAN_KEY>

## Polygon Mumbai (example)
# Chain ID: 80001
# Steps (after deploy):
# 1) Get contract addresses from deploy output.
# 2) Verify:
$ forge verify-contract --chain-id 80001 <TOKEN_ADDRESS> src/TechCrushVoteToken.sol:TechCrushVoteToken --etherscan-api-key <POLYGONSCAN_KEY>
$ forge verify-contract --chain-id 80001 <ELECTION_ADDRESS> src/TechCrushElection.sol:TechCrushElection --etherscan-api-key <POLYGONSCAN_KEY>

## Mainnet (production)
# Chain ID: 1
# Steps: same as above but ensure you have mainnet RPC and an Etherscan API key for mainnet verification.

# Using the helper scripts

## Manual verification with `scripts/verify.sh`
# Usage:
$ ./scripts/verify.sh <chain-id> <contract-name> <contract-address> <etherscan-key>
# Example (Sepolia token):
$ ./scripts/verify.sh 11155111 TechCrushVoteToken 0xYourTokenAddressHere $ETHERSCAN_KEY

## CI helper `scripts/ci_deploy_and_verify.sh`
# This script expects the following environment variables to be set (CI or local):
# - RPC_URL (e.g. https://eth-sepolia.g.alchemy.com/v2/<KEY>)
# - FORGE_PRIVATE_KEY (deployer private key)
# - CHAIN_ID (numeric)
# - ETHERSCAN_KEY (optional, for verification)
# Run locally for a test deployment and verification (example):
$ export RPC_URL="https://eth-sepolia.g.alchemy.com/v2/<KEY>"
$ export FORGE_PRIVATE_KEY="<YOUR_PRIVATE_KEY>"
$ export CHAIN_ID=11155111
$ export ETHERSCAN_KEY="<ETHERSCAN_KEY>" # optional
$ ./scripts/ci_deploy_and_verify.sh

# Artifact
# After a successful run in CI the script will save `deployed_addresses.env` which contains the deployed addresses.
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
