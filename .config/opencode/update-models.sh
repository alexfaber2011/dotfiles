#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="opencode.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_PATH="$SCRIPT_DIR/$CONFIG_FILE"

# Read the config
if [ ! -f "$CONFIG_PATH" ]; then
  echo "Error: $CONFIG_PATH not found"
  exit 1
fi

# Extract provider name (use first provider found)
PROVIDER=$(jq -r '.provider | keys[0]' "$CONFIG_PATH")
echo "Provider: $PROVIDER"

# Extract baseURL, resolving a "{env:VAR}" reference if present
BASE_URL_REF=$(jq -r ".provider.\"$PROVIDER\".options.baseURL" "$CONFIG_PATH")
BASE_URL_ENV_VAR=$(echo "$BASE_URL_REF" | sed -n 's/^{env:\(.*\)}$/\1/p')
if [ -n "$BASE_URL_ENV_VAR" ]; then
  BASE_URL="${!BASE_URL_ENV_VAR:-}"
  if [ -z "$BASE_URL" ]; then
    echo "Error: $BASE_URL_ENV_VAR is not set"
    exit 1
  fi
else
  BASE_URL="$BASE_URL_REF"
fi
echo "Base URL: $BASE_URL"

# Extract the env var name from apiKey (parse "{env:VAR_NAME}" format)
API_KEY_REF=$(jq -r ".provider.\"$PROVIDER\".options.apiKey" "$CONFIG_PATH")
ENV_VAR_NAME=$(echo "$API_KEY_REF" | sed -n 's/^{env:\(.*\)}$/\1/p')

if [ -z "$ENV_VAR_NAME" ]; then
  echo "Error: Could not parse API key reference: $API_KEY_REF"
  exit 1
fi

echo "API Key env var: $ENV_VAR_NAME"

# Check if the env var is set
API_KEY="${!ENV_VAR_NAME:-}"
if [ -z "$API_KEY" ]; then
  echo "Error: $ENV_VAR_NAME is not set"
  exit 1
fi

# Fetch models from the provider
echo "Fetching models from $BASE_URL/models ..."
MODELS_RESPONSE=$(curl -s -H "Authorization: Bearer $API_KEY" "$BASE_URL/models")

if [ -z "$MODELS_RESPONSE" ]; then
  echo "Error: Failed to fetch models (empty response)"
  exit 1
fi

# Extract model IDs from the response (OpenAI-compatible format: data[].id)
MODEL_IDS=$(echo "$MODELS_RESPONSE" | jq -r '.data[].id' 2>/dev/null)

if [ -z "$MODEL_IDS" ]; then
  echo "Error: No models found in response"
  exit 1
fi

echo "Found models:"
echo "$MODEL_IDS"

# Build the new models JSON object - model names as keys with empty objects
NEW_MODELS=$(echo "$MODEL_IDS" | jq -R -s 'split("\n") | map(select(length > 0)) | map({(.): {}}) | add')

echo "New models JSON:"
echo "$NEW_MODELS"

# Create backup
cp "$CONFIG_PATH" "${CONFIG_PATH}.bak"
echo "Backup created: ${CONFIG_PATH}.bak"

# Update the config with new models
jq --argjson new_models "$NEW_MODELS" --arg provider "$PROVIDER" '.provider[$provider].models = $new_models' "$CONFIG_PATH" > "${CONFIG_PATH}.tmp"
mv "${CONFIG_PATH}.tmp" "$CONFIG_PATH"

echo "Updated $CONFIG_PATH with new models"
