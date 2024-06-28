#!/bin/bash
set -e
KV=${1:-my-kv}
echo "CertName,CommonName,SAN Domains"

# Fetching certificate names directly in the loop, reducing redundancy
for CERTNAME in $(az keyvault certificate list --vault-name $KV | jq -r .[].name); do
    # Fetching certificate details in a single call to reduce redundancy
    CERT_DETAILS=$(az keyvault certificate show --name "$CERTNAME" --vault-name $KV)

    # Extracting required information using jq
    CN=$(echo "$CERT_DETAILS" | jq -r '.policy.x509CertificateProperties.subject' | awk -F", " '{print $1}' | sed 's/CN=//')
    SANS=$(echo "$CERT_DETAILS" | jq -r '.policy.x509CertificateProperties.subjectAlternativeNames.dnsNames[]?' | tr '\n' ' ')

    # Printing the results
    echo "$CERTNAME,$CN,$SANS"
done
