#!/bin/bash

# Clone or update acme.sh
echo
echo "📥 Cloning or updating acme.sh..."
echo

if [ -d "acme.sh" ]; then
    echo "acme.sh already exists — updating..."
    (cd acme.sh && git pull --ff-only) || true
else
    git clone https://github.com/neilpang/acme.sh
fi

echo
echo "🔐 Please provide your Azure DNS credentials."
echo "These will be used by acme.sh to complete the DNS-01 challenge."
echo

printf "Azure Subscription ID: "
read -r AZUREDNS_SUBSCRIPTIONID

printf "Azure Tenant ID: "
read -r AZUREDNS_TENANTID

printf "Azure Client ID (App ID): "
read -r AZUREDNS_APPID

# hide input for secret
printf "Azure Client Secret: "
stty -echo
read -r AZUREDNS_CLIENTSECRET
stty echo
printf "\n"

# Export variables for acme.sh
export AZUREDNS_SUBSCRIPTIONID="$AZUREDNS_SUBSCRIPTIONID"
export AZUREDNS_TENANTID="$AZUREDNS_TENANTID"
export AZUREDNS_APPID="$AZUREDNS_APPID"
export AZUREDNS_CLIENTSECRET="$AZUREDNS_CLIENTSECRET"

echo
echo "✅ You have provided the following Azure DNS credentials:"
echo "AZUREDNS_SUBSCRIPTIONID=$AZUREDNS_SUBSCRIPTIONID"
echo "AZUREDNS_TENANTID=$AZUREDNS_TENANTID"
echo "AZUREDNS_APPID=$AZUREDNS_APPID"
echo "AZUREDNS_CLIENTSECRET=********"
echo
echo "🚀 Azure DNS credentials set."
echo