#!/bin/bash

# Script to retrieve the public URL of a deployed Cloud Run service
# Usage: ./get-cloudrun-url.sh
# The script will prompt for service name, project ID, and region

set -e  # Exit on error

LOG_FILE="cloudrun_lookup.log"

# Log helper
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOG_FILE"
}

# Prompt for required input
read -p "Enter your Google Cloud Project ID: " PROJECT_ID
read -p "Enter the region of your Cloud Run service (e.g., us-central1): " REGION
read -p "Enter the Cloud Run service name: " SERVICE_NAME

log "Retrieving URL for Cloud Run service: $SERVICE_NAME in $REGION..."

# Attempt to retrieve the service URL
URL=$(gcloud run services describe "$SERVICE_NAME" \
  --platform=managed \
  --project="$PROJECT_ID" \
  --region="$REGION" \
  --format="value(status.url)" 2>>"$LOG_FILE")

# Check if URL was retrieved
if [ -z "$URL" ]; then
  log "❌ Failed to retrieve the URL. Make sure the service exists and you have access."
  exit 1
fi

log "✅ Cloud Run URL: $URL"
echo "Service is accessible at: $URL"
