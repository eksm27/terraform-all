#!/bin/sh

echo "🚀 Starting APP..."

export DB_HOST=$(jq -r '.db_host' $CONFIG_JSON)
export DB_USER=$(jq -r '.db_user' $CONFIG_JSON)
export DB_PASS=$(jq -r '.db_pass' $CONFIG_JSON)
export DB_NAME=$(jq -r '.db_name' $CONFIG_JSON)

echo "📌 DB_HOST=$DB_HOST"

exec python app.py