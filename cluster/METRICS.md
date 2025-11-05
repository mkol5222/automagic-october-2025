```bash

# in cluster folder
pwd
cd cluster
pwd 
# find first cluster member VM id
az vm list -o table

RG=$(terraform output -raw rg)
NAME=$(terraform output -raw name)
echo "$NAME in $RG"

FIRSTVM=$(az vm show --resource-group $RG --name "${NAME}1" --query "id" -o tsv)
echo $FIRSTVM

# show diagnostics settings for a VM
az monitor diagnostic-settings list --resource $FIRSTVM

# show metrics list for a VM
az monitor metrics  --help
az monitor metrics list-definitions --resource $FIRSTVM --output table

az monitor metrics list-namespaces --resource $FIRSTVM --output table
az monitor metrics list-definitions --resource $FIRSTVM --output table --namespace "CloudGuard"
az monitor metrics list-definitions --resource $FIRSTVM --output table --namespace "CloudGuard" | grep -i connections
az monitor metrics list-definitions --resource $FIRSTVM --output json --namespace "CloudGuard" |jq .
az monitor metrics list-definitions --resource $FIRSTVM --output json --namespace "CloudGuard" |jq '.[]| select(.name.value=="Num. connections")'
az monitor metrics list-definitions --resource $FIRSTVM --output json --namespace "CloudGuard" |jq '.[]| select(.name.value=="Num. connections").id'
CCID=$(az monitor metrics list-definitions --resource $FIRSTVM --output json --namespace "CloudGuard" |jq -r '.[]| select(.name.value=="Num. connections").id')
echo $CCID

az monitor metrics list --resource $FIRSTVM --output table

az monitor metrics list --resource $FIRSTVM --output table --namespace "CloudGuard" --metric 'Num. connections' --aggregation Maximum --interval PT1H

az monitor metrics list --resource $FIRSTVM --output table --namespace "CloudGuard" --metric 'CPU Idle Time (%)' --aggregation Maximum --interval PT1H --debug

az monitor metrics list --resource $FIRSTVM --output table --namespace "CloudGuard" --metric 'Outbound Flows' --aggregation Maximum --interval PT1H 

az monitor metrics list --help