#!/usr/bin/env bash
# Helper to verify contracts on Etherscan via forge
# Usage: ./scripts/verify.sh <chain-id> <contract-name> <contract-address> <etherscan-key>
set -euo pipefail
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <chain-id> <contract-name> <contract-address> <etherscan-key>"
  echo "Example: $0 11155111 TechCrushVoteToken 0x... <ETHERSCAN_KEY>"
  exit 1
fi
CHAIN_ID="$1"
CONTRACT_NAME="$2"
CONTRACT_ADDR="$3"
ETHERSCAN_KEY="$4"
case "$CONTRACT_NAME" in
  TechCrushVoteToken)
    SRC="src/TechCrushVoteToken.sol:TechCrushVoteToken"
    ;;
  TechCrushElection)
    SRC="src/TechCrushElection.sol:TechCrushElection"
    ;;
  *)
    echo "Unknown contract name: $CONTRACT_NAME"
    exit 1
    ;;
esac
forge verify-contract --chain-id "$CHAIN_ID" "$CONTRACT_ADDR" "$SRC" --etherscan-api-key "$ETHERSCAN_KEY"
