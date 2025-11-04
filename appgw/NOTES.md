```bash

# list all application gateways
az network application-gateway list -o table
# only ids
az network application-gateway list --query "[].id" -o tsv

# show diagnostics settings for an application gateway
FIRSTGW=$(az network application-gateway list --query "[0].id" -o tsv)
az monitor diagnostic-settings list --resource $FIRSTGW

# show metrics for an application gateway
# per hour
az monitor metrics list --resource $FIRSTGW --metric "TotalRequests" --interval PT1H --aggregation Total --output table
# per minute
az monitor metrics list --resource $FIRSTGW --metric "TotalRequests" --interval T1M --aggregation Total --output table

# find logs workspace from diagnostics settings
az monitor diagnostic-settings list --resource $FIRSTGW --query "[].workspaceId" -o tsv
# list all log analytics workspaces
az monitor log-analytics workspace list -o table
# print customer id of LAW
LAW=$(az monitor diagnostic-settings list --resource $FIRSTGW --query "[0].workspaceId" -o tsv)
echo $LAW
az monitor log-analytics workspace show --ids $LAW --query customerId -o tsv
LAWID=$(az monitor log-analytics workspace show --ids $LAW --query customerId -o tsv)
echo $LAWID

# query logs for requests
az monitor log-analytics query --help
# list tables in log analytics workspace

# query access logs
az monitor log-analytics query -w $LAWID  --analytics-query "AGWAccessLogs | take 1" --output json | jq .

# time span of 24h, summarize count per hour
az monitor log-analytics query -w $LAWID  --analytics-query "AGWAccessLogs | summarize count() by bin(TimeGenerated, 1h)" --output table
# time span of 1h, summarize count per Host and status code
az monitor log-analytics query -w $LAWID  --analytics-query "AGWAccessLogs | where TimeGenerated > ago(1h) | summarize count() by Host, HttpStatus" --output table

```
