#!/bin/bash
set -e
# Setting default resource group, you can pass resource group as a parameter too
RG=${1:-mygroup}
# Setting default subscription, a good idea to set a subscription if you have multiple subscriptions
SUB=mysub
# Get a list of CDN profile
CDN_PROFILE=$(az cdn profile list --subscription $SUB -g $RG | jq -r .[].name)
# I want the final output to be in CSV format, so setting headers 
echo -e "Profile,Endpoint,HostName,VaultName,SecretName,SecretVersion"
# Loop through list of CDN profiles
for PROFILE in $CDN_PROFILE;
do
    # Get a list of CDN endpoints
    ENDPOINTS=$(az cdn endpoint list --subscription $SUB -g $RG --profile-name $PROFILE | jq -r .[].name)
    # Loop through the list of CDN endpoints
    for ENDPOINT in $ENDPOINTS;
    do
        # Parsing output of custom domain to filer HostName, VaultName, SecretName and SecretVersion
        HostName=$(az cdn custom-domain list --subscription $SUB -g $RG --profile-name $PROFILE --endpoint-name $ENDPOINT | jq -r '.[].hostName')
        VaultName=$(az cdn custom-domain list --subscription $SUB -g $RG --profile-name $PROFILE --endpoint-name $ENDPOINT | jq -r '.[].customHttpsParameters.certificateSourceParameters.vaultName')
        SecretName=$(az cdn custom-domain list --subscription $SUB -g $RG --profile-name $PROFILE --endpoint-name $ENDPOINT | jq -r '.[].customHttpsParameters.certificateSourceParameters.secretName')
        SecretVersion=$(az cdn custom-domain list --subscription $SUB -g $RG --profile-name $PROFILE --endpoint-name $ENDPOINT | jq -r '.[].customHttpsParameters.certificateSourceParameters.secretVersion')
        # Output Profile, Endpoint, HostName, VaultName, SecretName and SecretVersion
        echo -e "$PROFILE,$ENDPOINT,$HostName,$VaultName,$SecretName,$SecretVersion"
    done
done