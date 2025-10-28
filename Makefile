login: sp-login
sp-login:
	./scripts/sp-login.sh

management:  management-up
management-up:
	cd management && ./up.sh
management-down:
	cd management && ./down.sh
management-serial:
	cd management && ./serial.sh
management-info:
	cd management && ./info.sh
management-ssh:
	cd management && ./ssh.sh
management-api:
	cd management && ./api.sh
management-az:
	cd management && ./az.sh

# alias
cpman-ssh: management-ssh
cpman-api: management-api
cpman-info: management-info
cpman-serial: management-serial
cpman-down: management-down

cpman: management-up management-api policy management-info

vmss: vmss-up
vmss-up:
	cd vmss && ./up.sh
vmss-down:
	cd vmss && ./down.sh
vmss-serial:
	cd vmss && ./serial.sh
vmss-ssh:
	cd vmss && ./ssh.sh
vmss-info:
	cd vmss && ./info.sh
vmss-cme:
	cd vmss && ./cme.sh

### POLICY

policy: policy-up

policy-up:
	cd policy && ./up.sh

### LINUX

linux: linux-up
linux-up:
	cd linux && ./up.sh
linux-down:
	cd linux && ./down.sh
linux-serial:
	cd linux && ./serial.sh
linux-ssh:
	cd linux && ./ssh.sh
linux-info:
	cd linux && ./info.sh

fwon: linux-fwon
fwoff: linux-fwoff
linux-fwon:
	cd linux && ./fwon.sh
linux-fwoff:
	cd linux && ./fwoff.sh

### CLUSTER

cluster: cluster-up
cluster-up:
	cd cluster && ./up.sh
cluster-down:
	cd cluster && ./down.sh
cluster-serial:
	cd cluster && ./serial.sh
cluster-ssh:
	cd cluster && ./ssh.sh
cluster-info:
	cd cluster && ./info.sh
cluster-cme:
	cd cluster && ./cme.sh

remote-linux-ssh:
	cd remote && ./ssh-linux.sh

cluster-linux-ssh:
	cd cluster && ./ssh-linux.sh
cluster-pass-reset:
	cd cluster && ./pass-reset.sh 0
	cd cluster && ./pass-reset.sh 1
cluster-ssh: cluster-ssh1
cluster-ssh1:
	cd cluster && ./ssh.sh 0
cluster-ssh2:
	cd cluster && ./ssh.sh 1
cluster-fwon:
	cd cluster && ./fwon.sh
cluster-fwoff:
	cd cluster && ./fwoff.sh

### utils
er:
	./scripts/er.sh

down: linux-down vmss-down cluster-down management-down
