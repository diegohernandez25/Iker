run:
	./mvnw clean spring-boot:run

build:
	./mvnw install dockerfile:build

mount:
	docker run -p 8080:8080 --name payment -t springio/payment:latest

stop:
	docker stop payment
	docker rm payment
