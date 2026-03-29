#!/bin/bash
set -e

REGION="ap-south-1"
BUCKET="state-v1"
DYNAMO="terraform-lock"

echo "🔍 Checking S3 bucket..."

if aws s3api head-bucket --bucket $BUCKET 2>/dev/null; then
  echo "✅ S3 bucket exists"
else
  echo "🚀 Creating S3 bucket..."
  aws s3 mb s3://$BUCKET --region $REGION

  echo "🔐 Enabling versioning..."
  aws s3api put-bucket-versioning \
    --bucket $BUCKET \
    --versioning-configuration Status=Enabled
fi

echo "🔍 Checking DynamoDB table..."

if aws dynamodb describe-table --table-name $DYNAMO --region $REGION 2>/dev/null; then
  echo "✅ DynamoDB exists"
else
  echo "🚀 Creating DynamoDB table..."
  aws dynamodb create-table \
    --table-name $DYNAMO \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region $REGION
fi

echo "✅ Backend ready!"