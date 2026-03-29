#!/bin/bash
set -e

# Usage check
if [ -z "$1" ]; then
  echo "Usage: $0 <aws-profile>"
  exit 1
fi

PROFILE=$1
REGION="ap-south-1"
BUCKET="state-v1"
DYNAMO="terraform-lock"

echo "Using profile: $PROFILE"

# Check S3 bucket
if aws s3api head-bucket --bucket $BUCKET --profile $PROFILE 2>/dev/null; then
  echo "S3 bucket exists"
else
  echo "Creating S3 bucket..."
  aws s3 mb s3://$BUCKET --region $REGION --profile $PROFILE

  aws s3api put-bucket-versioning \
    --bucket $BUCKET \
    --versioning-configuration Status=Enabled \
    --profile $PROFILE
fi

# Check DynamoDB
if aws dynamodb describe-table \
  --table-name $DYNAMO \
  --region $REGION \
  --profile $PROFILE >/dev/null 2>&1; then

  echo "DynamoDB exists"
else
  echo "Creating DynamoDB table..."

  aws dynamodb create-table \
    --table-name $DYNAMO \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region $REGION \
    --profile $PROFILE
fi

echo "Backend ready!"