run:
	./mvnw clean spring-boot:run

build:
	./mvnw install dockerfile:build

mount:
	docker run -p 8080:8080 --name payment -t springio/payment:latest

mount_detach:
	docker run -p 8080:8080 --name payment -t springio/payment:latest -d

stop:
	docker stop payment
	docker rm payment
