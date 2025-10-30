```bash

# sample dataset
ls -la ../_flowlogs/tmp*

# all
ls -rt ../_flowlogs/tmp* | xargs cat

# review
ls -rt ../_flowlogs/tmp* | xargs cat | jq .

# NIC?
ls -rt ../_flowlogs/tmp* | xargs cat | jq . | less

#
ls -rt ../_flowlogs/tmp* | xargs cat | jq '. | keys'
ls -rt ../_flowlogs/tmp* | xargs cat | jq -c | head -1 | jq '.records[0] | keys'
ls -rt ../_flowlogs/tmp* | xargs cat | jq -c | head -1 | jq '.records[0]'

# all aclIDs
ls -rt ../_flowlogs/tmp* | xargs cat | jq -r '.records[]| keys'
# flowRecords.flows[]
ls -rt ../_flowlogs/tmp* | xargs cat | jq -r '.records[]| .flowRecords.flows[] | .aclID'
ls -rt ../_flowlogs/tmp* | xargs cat | jq -r '.records[]| .flowRecords.flows[] | .aclID' | sort | uniq -c

# rules?
ls -rt ../_flowlogs/tmp* | xargs cat | jq -r '.records[]| .flowRecords.flows[] '
# flowGroups[] rule

ls -rt ../_flowlogs/tmp* | xargs cat | jq -r '.records[]| .flowRecords.flows[] | .flowGroups[]|.rule'

# logs
ls -rt ../_flowlogs/tmp* | xargs cat | jq -r '.records[]| .flowRecords.flows[] | .flowGroups[]|.flowTuples[]'

ls -rt ../_flowlogs/tmp* | xargs cat | jq -r '.records[]| .flowRecords.flows[] | .flowGroups[]|.flowTuples[]' | grep 10.200.200.4 | sort

ls -rt ../_flowlogs/tmp* | xargs cat | jq -r '.records[]| .flowRecords.flows[] | .flowGroups[]|.rule' | sort | uniq -c

# add rule name
ls -rt ../_flowlogs/tmp* | xargs cat | jq -r '.records[]| .macAddress as $mac |.flowRecords.flows[] | .flowGroups[]| .rule as $rule | .flowTuples[] | "\(.),\($rule),\($mac)" '  | grep 10.200.200.4 | sort -t, -k1,1

# targetResourceID macAddress
ls -rt ../_flowlogs/tmp* | xargs cat | jq -r '.records[]  | .macAddress' | sort | uniq -c

ls -rt ../_flowlogs/tmp* | xargs cat | jq -r '.records[]  | .targetResourceID' | sort | uniq -c

### list azure NICs, show MAC
az network nic list --query '[].{name:name, macAddress:macAddress, id:id}' --output table
```