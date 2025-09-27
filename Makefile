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
management-api:
	cd management && ./api.sh



	