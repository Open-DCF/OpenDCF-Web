#!/bin/bash
# This script runs on the Google VM every 5 minutes

API_TOKEN="{{ cf_token }}"
RECORDS_DATA="{{ cf_data }}"

# Get the current public IP
IP=$(curl -s https://ifconfig.me)

# Loop through each record string
for entry in $RECORDS_DATA; do
    # Split the entry into parts
    IFS=':' read -r ZONE_ID RECORD_ID DOMAIN_NAME <<< "$entry"
    
    echo "Updating $DOMAIN_NAME to $IP..."

    curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
         -H "Authorization: Bearer $API_TOKEN" \
         -H "Content-Type: application/json" \
         -d "{
              \"type\": \"A\",
              \"name\": \"$DOMAIN_NAME\",
              \"content\": \"$IP\",
              \"ttl\": 120,
              \"proxied\": true
            }"
done