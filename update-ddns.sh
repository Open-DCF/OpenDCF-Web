#!/bin/bash
API_TOKEN="{{ cf_token }}"
ZONE_ID="{{ cf_zone }}"
# Ansible will turn that string into a space-separated list for bash
RECORD_IDS="{{ lookup('env', 'CF_RECORD_IDS') | replace(',', ' ') }}"

IP=$(curl -s https://ifconfig.me)

for RECORD_ID in $RECORD_IDS; do
    curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
         -H "Authorization: Bearer $API_TOKEN" \
         -H "Content-Type: application/json" \
         --data "{\"type\":\"A\",\"name\":\"{{ domain_name }}\",\"content\":\"$IP\",\"ttl\":120,\"proxied\":true}"
done