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
