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