sp-login:
	./scripts/sp-login.sh

management:  management-up
management-up:
	cd management && ./up.sh
management-down:
	cd management && ./down.sh
	