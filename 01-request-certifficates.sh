#!/bin/bash

# Cleanup any previous certifficates and acme.sh data
export CERTDIR=certificates
rm -rf ${CERTDIR}
rm -rf ${HOME}/.acme.sh

# Check if user is logged in to OpenShift CLI
oc whoami > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo
  echo "You are not logged in to OpenShift CLI. Please log in and try again."
  echo
  exit 1
fi 
echo
echo "You are logged in to OpenShift CLI as: $(oc whoami)"
echo

# Set the domain names for the certifficates
export LE_API=$(oc whoami --show-server | cut -f 2 -d ':' | cut -f 3 -d '/' | sed 's/-api././')
export LE_WILDCARD=$(oc get ingresscontroller default -n openshift-ingress-operator -o jsonpath='{.status.domain}')

# Show variables being used as domain names for the certifficates
echo "Domain names for the certifficates:"
echo ${LE_API}
echo ${LE_WILDCARD}
echo

# Portable interactive prompt for email address
printf "Please enter your email address for Let's Encrypt notifications: "
read -r EMAIL
echo

# set account with ZeroSSL and set it as default CA
acme.sh/acme.sh  --register-account  -m ${EMAIL} --server zerossl
acme.sh/acme.sh --set-default-ca --server zerossl

# Issue certifficates using DNS-01 challenge with Azure DNS
acme.sh/acme.sh --log --issue -d "${LE_API}" -d "*.${LE_WILDCARD}" --dns dns_azure

# Install the certifficates to a specific directory

mkdir -p ${CERTDIR}

acme.sh/acme.sh --install-cert -d "${LE_API}" -d "*.${LE_WILDCARD}" \
  --cert-file ${CERTDIR}/cert.pem \
  --key-file ${CERTDIR}/key.pem \
  --fullchain-file ${CERTDIR}/fullchain.pem \
  --ca-file ${CERTDIR}/ca.cer

echo
echo "Certifficates have been issued and installed to the '${CERTDIR}' directory."
echo