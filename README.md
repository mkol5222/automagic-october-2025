# Check Point Automagic October 2025

CloudGuard lab to discover automation of Check Point products and policy.


## Prerequisites
- Github account
- Azure subscription with owner role
- SmartConsole R82 installed on your computer


## Azure

Lab is depending on *dedicated Azure Service Principal* with Owner role on subscription level. This is created by user manually in advance in [Azure Shell](https://shell.azure.com/).

Open [Azure Shell](https://shell.azure.com/) and run following command to obtain istructions what to do back in your CodeSpace/DevContainer terminal:

```bash
# inspect what will be done
curl -sL https://run.klaud.online/labspx.sh
# run it now IN AZURE SHELL
bash <(curl -sL https://run.klaud.online/labspx.sh)
```

This returned sequence of commands that should be run in your CodeSpace/DevContainer terminal similar to this:

```bash
    # example only - USE REAL OUTPUT FROM AZURE SHELL
    touch .env

    dotenvx set TF_VAR_envId "356e0a0d"
    dotenvx set TF_VAR_subscriptionId 00000000-0000-4000-8000-000000000000
    dotenvx set TF_VAR_tenant 11111111-1111-4111-8111-111111111111
    dotenvx set TF_VAR_appId 22222222-2222-4222-8222-222222222222
    dotenvx set TF_VAR_password "USEpLz1#qT9eWmKYOUR-OWN-SECRETrJgZxAo!sVdChEt"
    dotenvx set TF_VAR_displayName "sp-automagic-356e0a0d"

    # verify stored secrets in the root of your repository
    dotenvx run -- env | grep TF_VAR_
```

This produced `.env` file is used by Terraform and other automation tools to authenticate in Azure and manage resources.
There is also unique environment ID used to tag and name resources created in Azure.

Login to Azure with your new Azure Service Principal:

```bash
az login --service-principal -u $(dotenvx get TF_VAR_appId) -p $(dotenvx get TF_VAR_password) --tenant $(dotenvx get TF_VAR_tenant)
az account set --subscription $(dotenvx get TF_VAR_subscriptionId)
az account show -o table

# or simply BETTER use prepared scripts
make sp-login
```

## Check Point Security Management

This lab will produce new deployment of Check Point Security Management in Azure.
It will be used to manage Check Point CloudGuard products and policies.

In your CodeSpace/DevContainer terminal run:
```bash
# deploy management, wait for API to be ready, create lab policy
# and tell IP and password to login using SmartConsole R82
time make cpman
# expected time to finish ~20 minutes
```

Optional: once Management VM exists, you can monitor initialization progress on VM console. Consider splitting the terminal window and run:

```bash
# if you are too early to succeed, just run again ;-)
make cpman-serial
```


## Check Point CloudGuard Network Security gateways deployed as Azure VMSS

Continue to this step only after you have Check Point Security Management deployed and ready.
You should be able to login to it using SmartConsole R82 and see policy package called `VMSS` first.

In your CodeSpace/DevContainer new terminal run:
```bash
time make vmss
# expected time to finish ~5 minutes
```

This deployed Check Point CloudGuard Network Security gateways in Azure VMSS (Virtual Machine Scale Set).
We need to configure CME - Cloud Management Extension running on Security Management
to enable it to discover and provision new gateways as objects in the policy.

In your CodeSpace/DevContainer terminal run:
```bash
# get commands first
make vmss-cme
# login to management using SSH to run them
make cpman-ssh

# monitor cme.log on management or use SmartConsole logs view of blade:CME
```


## Linux test VM

Lets deploy Linux VM to be protected by Check Point CloudGuard Network Security gateways which will allow us to test connectivity.

In your CodeSpace/DevContainer terminal run:
```bash
time make linux
# expected time to finish ~5 minutes or less
```

Once Linux is deployed, you can SSH to it using:

```bash
make linux-ssh
# try to see your source public IP address
curl ifconfig.me
# not yet connected via firewall - so no logs in SmartConsole
```

This is how you route traffic from Linux VM via Check Point CloudGuard Network Security gateways:

```bash
make fwon

# vs disable it again for direct access to Internet LATER
make fwoff
```

You can probe traffic in the loop on Linux VM:

```bash
# probe connectivity via firewall
make linux-ssh
# LINUX session command
while true; do date; curl -s ifconfig.me -m1; echo; sleep 2; echo; done
```


## Cleanup

This is how you remove all Azure resources created by this lab.

In your CodeSpace/DevContainer terminal run:
```bash
make down
```