#!/usr/bin/env bash
# CI helper to deploy and optionally verify contracts using forge
# Usage: CI environment variables required:
#   RPC_URL, FORGE_PRIVATE_KEY, CHAIN_ID, ETHERSCAN_KEY (optional for verification)
set -euo pipefail
if [ -z "${RPC_URL:-}" ] || [ -z "${FORGE_PRIVATE_KEY:-}" ] || [ -z "${CHAIN_ID:-}" ]; then
  echo "RPC_URL, FORGE_PRIVATE_KEY and CHAIN_ID must be set"
  exit 1
fi

# Deploy and save traces
echo "Deploying contracts to $RPC_URL (chain $CHAIN_ID)"
forge script script/DeployVoting.s.sol:DeployVoting --broadcast --private-key "$FORGE_PRIVATE_KEY" --rpc-url "$RPC_URL" -vvvv

# Find the latest run-latest.json for the DeployVoting script
RUN_JSON=$(ls -td broadcast/DeployVoting.s.sol/*/run-latest.json 2>/dev/null | head -n 1 || true)
if [ -z "$RUN_JSON" ]; then
  echo "Deployment JSON not found, aborting artifact/verification steps"
  exit 0
fi

echo "Found run JSON: $RUN_JSON"
# Extract deployed contract addresses from the broadcast JSON
# We look for all values called contractAddress or contract_address
TOKEN_ADDR=$(jq -r '(.transactions[]?.contractAddress // .transactions[]?.contract_address) | select(.!=null)' "$RUN_JSON" | sed -n '1p' || true)
ELECTION_ADDR=$(jq -r '(.transactions[]?.contractAddress // .transactions[]?.contract_address) | select(.!=null)' "$RUN_JSON" | sed -n '2p' || true)

# Print and save to file
echo "token=$TOKEN_ADDR" > deployed_addresses.env
echo "election=$ELECTION_ADDR" >> deployed_addresses.env

if [ -n "${GITHUB_ACTIONS:-}" ]; then
  # Save as artifacts (GitHub actions will pick up the file in later steps)
  echo "Deployed addresses saved to deployed_addresses.env"
fi

# If etherscan key provided, attempt verification
if [ -n "${ETHERSCAN_KEY:-}" ]; then
  echo "Verifying contracts on Etherscan"
  if [ -n "$TOKEN_ADDR" ]; then
    forge verify-contract --chain-id "$CHAIN_ID" "$TOKEN_ADDR" src/TechCrushVoteToken.sol:TechCrushVoteToken --etherscan-api-key "$ETHERSCAN_KEY" || echo "Token verify failed"
  fi
  if [ -n "$ELECTION_ADDR" ]; then
    forge verify-contract --chain-id "$CHAIN_ID" "$ELECTION_ADDR" src/TechCrushElection.sol:TechCrushElection --etherscan-api-key "$ETHERSCAN_KEY" || echo "Election verify failed"
  fi
else
  echo "ETHERSCAN_KEY not set: skipping verification"
fi

# Print final summary
echo "Deployment complete. Token: $TOKEN_ADDR | Election: $ELECTION_ADDR"
exit 0
