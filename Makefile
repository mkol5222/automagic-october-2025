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

