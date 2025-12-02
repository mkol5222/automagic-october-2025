
Linux behind VMSS. 10.101.2.4 is front-end IP of CGNS VMSS deployment backend LB.
How many times I get one of instanes in VMSS scale-set? (notice CN of Gaia OS portal with hostname)

```shell
make linux-ssh
# azureuser@automagic-linux-f0158ccb:~$ 
(for i in {1..50}; do curl -vvv https://10.101.2.4 -k  2>&1 | grep CN; done) | sort | uniq -c
    #  24 *  subject: O=cpman-f0158ccb..t3ymyf; CN=ctrl--vmss-f0158ccb_0--AUTOMAGIC-VMSS-F0158CCB VPN Certificate
    #  26 *  subject: O=cpman-f0158ccb..t3ymyf; CN=ctrl--vmss-f0158ccb_1--AUTOMAGIC-VMSS-F0158CCB VPN Certificate
```