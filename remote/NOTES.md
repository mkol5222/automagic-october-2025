```bash

# create SP in Azure Shell and login SP in CodeSpace/DevContainer

# deploy management, with policy
make login
time make cpman

# once done, login SmartConsole R82
make cpman-info

# deploy cluster
time make cluster

# add cluster to SmartConsole with command from
name cluster-cme

```