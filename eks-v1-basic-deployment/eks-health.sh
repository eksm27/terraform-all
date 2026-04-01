#!/bin/bash

#########################################
# CONFIG
#########################################

CLUSTER_NAME="test01"
REGION="ap-south-1"
LOG_FILE="./eks-health.log"
ERROR_COUNT=0
SLEEP_INTERVAL=10   # seconds

#########################################
# GET ENDPOINT
#########################################

ENDPOINT=$(aws eks-v1-basic-deployment describe-cluster \
  --name $CLUSTER_NAME \
  --region $REGION \
  --query "cluster.endpoint" \
  --output text)

echo "Monitoring EKS Endpoint: $ENDPOINT"
echo "Press CTRL+C to stop..."
echo "----------------------------------"

#########################################
# LOOP
#########################################

while true
do
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

  HTTP_CODE=$(curl -k -s -o /dev/null -w "%{http_code}" $ENDPOINT/healthz)

  if [ "$HTTP_CODE" == "200" ]; then
    STATUS="SUCCESS"
  else
    STATUS="FAILURE"
    ERROR_COUNT=$((ERROR_COUNT + 1))
  fi

  LOG="$TIMESTAMP | Status: $STATUS | HTTP_CODE: $HTTP_CODE | TotalErrors: $ERROR_COUNT"

  echo "$LOG"
  echo "$LOG" >> $LOG_FILE

  sleep $SLEEP_INTERVAL
done