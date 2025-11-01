IPSec blade not enabled:
```
[Expert@ha1:0]# cd "${FWDIR}/scripts" && "${FWDIR}"/scripts/cloud_metrics_azure.py
send_metric - INFO - Starting...
Traceback (most recent call last):
  File "/opt/CPsuite-R82/fw1/scripts/cloud_cpstat_parser.py", line 107, in get_cpstat
    return [(m, int(metrices_values[m]), metrics_units[m]) for m in
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/opt/CPsuite-R82/fw1/scripts/cloud_cpstat_parser.py", line 107, in <listcomp>
    return [(m, int(metrices_values[m]), metrics_units[m]) for m in
                ^^^^^^^^^^^^^^^^^^^^^^^
ValueError: invalid literal for int() with base 10: '?'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/opt/CPsuite-R82/fw1/scripts/cloud_metrics_azure.py", line 544, in <module>
    status = main(sys.argv[1:])
             ^^^^^^^^^^^^^^^^^^
  File "/opt/CPsuite-R82/fw1/scripts/cloud_metrics_azure.py", line 532, in main
    metrics = collect_cpstat_metrics()
              ^^^^^^^^^^^^^^^^^^^^^^^^
  File "/opt/CPsuite-R82/fw1/scripts/cloud_cpstat_parser.py", line 124, in collect_cpstat_metrics
    metrics += get_cpstat(*metric)
               ^^^^^^^^^^^^^^^^^^^
  File "/opt/CPsuite-R82/fw1/scripts/cloud_cpstat_parser.py", line 113, in get_cpstat
    raise MetricsKeyError(
cloud_cpstat_parser.MetricsKeyError: "['Encrypted packets', 'Decrypted packets', 'Encryption errors', 'Decryption errors', 'IKE current SAs', 'IKE no response from peer (initiator errors)', 'IPsec current Inbound SAs', 'IPsec current Outbound SAs', 'IPsec number of VPN-1 peers', 'IPsec number of VPN-1 RA peers'] dict seems to retrieve string metrics. Only numerical metrics allowed. Error:invalid literal for int() with base 10: '?'"
```

Once IPSEC blade enabled:
```
[Expert@ha1:0]# cd "${FWDIR}/scripts" && "${FWDIR}"/scripts/cloud_metrics_azure.py
send_metric - INFO - Starting...
Traceback (most recent call last):
  File "/opt/CPsuite-R82/fw1/scripts/cloud_metrics_azure.py", line 544, in <module>
    status = main(sys.argv[1:])
             ^^^^^^^^^^^^^^^^^^
  File "/opt/CPsuite-R82/fw1/scripts/cloud_metrics_azure.py", line 536, in main
    send_cpstat_metrics(metrics)
  File "/opt/CPsuite-R82/fw1/scripts/cloud_metrics_azure.py", line 410, in send_cpstat_metrics
    conf = load_azure_configuration()
           ^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/opt/CPsuite-R82/fw1/scripts/cloud_metrics_azure.py", line 127, in load_azure_configuration
    instance = json.loads(azure_file.read())
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/opt/CPsuite-R82/fw1/Python/lib/python3.11/json/__init__.py", line 346, in loads
    return _default_decoder.decode(s)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/opt/CPsuite-R82/fw1/Python/lib/python3.11/json/decoder.py", line 337, in decode
    obj, end = self.raw_decode(s, idx=_w(s, 0).end())
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/opt/CPsuite-R82/fw1/Python/lib/python3.11/json/decoder.py", line 355, in raw_decode
    raise JSONDecodeError("Expecting value", s, err.value) from None
json.decoder.JSONDecodeError: Expecting value: line 1 column 1 (char 0)
```

```
curl_cli -H 'Metadata:true' 'http://169.254.169.254/metadata/instance?api-version=2019-06-01' 

# 2023-07-01

curl_cli -H 'Metadata:true' 'http://169.254.169.254/metadata/instance?api-version=2023-07-01' 

curl_cli -I http://169.254.169.254

curl_cli -H "Metadata:true" "http://169.254.169.254/metadata/instance?api-version=2023-07-01" 

```

```shell
az vm list | jq -r '.[].id'
/subscriptions/f4ad5e85-ec75-4321-8854-ed7eb611f61d/resourceGroups/AUTOMAGIC-CLINUX-639EC4AE/providers/Microsoft.Compute/virtualMachines/automagic-clinux-639ec4ae
/subscriptions/f4ad5e85-ec75-4321-8854-ed7eb611f61d/resourceGroups/AUTOMAGIC-CLUSTER-639EC4AE/providers/Microsoft.Compute/virtualMachines/ha1
/subscriptions/f4ad5e85-ec75-4321-8854-ed7eb611f61d/resourceGroups/AUTOMAGIC-CLUSTER-639EC4AE/providers/Microsoft.Compute/virtualMachines/ha2
/subscriptions/f4ad5e85-ec75-4321-8854-ed7eb611f61d/resourceGroups/AUTOMAGIC-MANAGEMENT-639EC4AE/providers/Microsoft.Compute/virtualMachines/cpman-639ec4ae

$ az monitor metrics list-namespaces --resource /subscriptions/f4ad5e85-ec75-4321-8854-ed7eb611f61d/resourceGroups/AUTOMAGIC-CLUSTER-639EC4AE/providers/Microsoft.Compute/virtualMachines/ha1 -o table
This command is in preview and under development. Reference and support levels: https://aka.ms/CLI_refstatus
Classification    Metric Namespace Name
----------------  ---------------------------------
Platform          Microsoft.Compute/virtualMachines
Custom            CloudGuard

az monitor metrics --help
az monitor metrics list-definitions

VM=/subscriptions/f4ad5e85-ec75-4321-8854-ed7eb611f61d/resourceGroups/AUTOMAGIC-CLUSTER-639EC4AE/providers/Microsoft.Compute/virtualMachines/ha1 

az monitor metrics list-namespaces --resource $VM -o table

az monitor metrics list-definitions --resource $VM --namespace CloudGuard -o table
az monitor metrics list-definitions --resource $VM --namespace CloudGuard -o json
az monitor metrics list-definitions --resource $VM --namespace CloudGuard -o json | jq -r '.[] |.name.value'
az monitor metrics list-definitions --resource $VM --namespace CloudGuard -o json | jq -r '.[] |.id' | grep "Num"

M='Num. connections'
M1='/subscriptions/f4ad5e85-ec75-4321-8854-ed7eb611f61d/resourceGroups/AUTOMAGIC-CLUSTER-639EC4AE/providers/Microsoft.Compute/virtualMachines/ha1/providers/microsoft.insights/metricdefinitions/CloudGuard/Num. connections'
az monitor metrics --help

az monitor --help

echo az monitor metrics list   --resource $VM   --metric "$M"   --namespace CloudGuard   --interval PT1M   -o table
az monitor metrics list   --resource $VM   --metric "$M1"  

az monitor metrics list --resource $VM --metric "Percentage CPU"

cat $FWDIR/conf/cloud_cpstat_parser.json


az monitor diagnostic-settings list --resource $VM