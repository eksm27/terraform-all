#!/bin/sh

if [ -z "$CONFIG_JSON" ]; then
  echo "❌ CONFIG_JSON not provided"
  exit 1
fi

if [ ! -f "$CONFIG_JSON" ]; then
  echo "❌ Config file not found: $CONFIG_JSON"
  exit 1
fi

echo "📦 Loading configuration from: $CONFIG_JSON"

export DB_HOST=$(jq -r '.db_host' $CONFIG_JSON)
export DB_PORT=$(jq -r '.db_port' $CONFIG_JSON)
export DB_NAME=$(jq -r '.db_name' $CONFIG_JSON)
export DB_USER=$(jq -r '.db_user' $CONFIG_JSON)
export DB_PASS=$(jq -r '.db_pass' $CONFIG_JSON)

export S3_BUCKET=$(jq -r '.s3_bucket' $CONFIG_JSON)
export S3_PATH=$(jq -r '.s3_path' $CONFIG_JSON)
export REGION=$(jq -r '.region' $CONFIG_JSON)
export CLOUDFRONT_URL=$(jq -r '.cloudfront_url' $CONFIG_JSON)

echo "✅ Configuration Loaded Successfully"

echo "🚀 Starting Application..."
exec python app.py