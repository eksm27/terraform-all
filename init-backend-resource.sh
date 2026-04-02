#!/bin/bash
# Usage: ./init-backend-resource.sh <aws-profile> <layer>
# Layer can be 'network' or 'ec2'

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <aws-profile> <layer>"
  exit 1
fi

AWS_PROFILE=$1
LAYER=$2
S3_BUCKET="state-v1"

# Configure backend key and dynamodb table per layer
if [ "$LAYER" == "network" ]; then
  STATE_KEY="network/terraform.tfstate"
  DYNAMO_TABLE="terraform-network-lock"
elif [ "$LAYER" == "app" ]; then
  STATE_KEY="app/terraform.tfstate"
  DYNAMO_TABLE="terraform-app-lock"
elif [ "$LAYER" == "eks" ]; then
  STATE_KEY="eks/terraform.tfstate"
  DYNAMO_TABLE="terraform-eks-lock"
else
  echo "Invalid layer. Use 'network' or 'app' or 'eks'."
  exit 1
fi

# Check if DynamoDB table exists, create if missing
TABLE_CHECK=$(aws dynamodb describe-table --table-name $DYNAMO_TABLE --profile $AWS_PROFILE 2>/dev/null || echo "NOTFOUND")
if [[ "$TABLE_CHECK" == "NOTFOUND" ]]; then
  echo "DynamoDB table $DYNAMO_TABLE not found. Creating..."
  aws dynamodb create-table \
    --table-name $DYNAMO_TABLE \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --profile $AWS_PROFILE
else
  echo "DynamoDB table $DYNAMO_TABLE exists."
fi

# Initialize Terraform backend for the layer
terraform -chdir=./$LAYER init \
  -backend-config="bucket=$S3_BUCKET" \
  -backend-config="key=$STATE_KEY" \
  -backend-config="region=ap-south-1" \
  -backend-config="dynamodb_table=$DYNAMO_TABLE" \
  -reconfigure \
  -upgrade \
  -input=false \
  -force-copy