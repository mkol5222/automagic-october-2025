#!/bin/bash

# get (read-only) credentials to list VMSS in Azure 
CLIENT_ID=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_appId)
CLIENT_SECRET=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_password)
TENANT_ID=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_tenant)
SUBSCRIPTION_ID=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_subscriptionId)


ENVID=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_envId)
RG=$(cd ../management/; terraform output -raw rg)
CPMAN_NAME=$(cd ../management/; terraform output -raw name)
CPMAN_IP=$(az vm show -d --resource-group "$RG" --name "$CPMAN_NAME" --query "publicIps" -o tsv)
echo Management IP is $CPMAN_IP

# TF_VAR_VMSS_SIC_KEY
OTP=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_VMSS_SIC_KEY)
echo "SIC key (OTP) is: $OTP"

# configure CME for VMSS - use real credentials!!! (example below is revoked RO Az SP)
# command to run @cpman
echo "Run these commands one by one at cpman SSH prompt." 
echo "  Hint: No need to restart CME after fist command"
echo 
echo
echo autoprov_cfg init Azure -mn mgmt -tn vmss_template -otp \'$OTP\' -ver R82 -po vmss -cn ctrl -sb $SUBSCRIPTION_ID -at $TENANT_ID -aci $CLIENT_ID -acs \'$CLIENT_SECRET\'
echo 
echo autoprov_cfg set template -tn vmss_template -ia -ips
echo
echo "Monitor CME on cpman VM with:"
echo '   tail -f /var/log/CPcme/cme.log'
echo 
echo "Enter cpman CLI using:"
echo "   make cpman-ssh"
echo