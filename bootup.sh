echo "Starting Review Service"
(cd reviewService && docker-compose up -d)

echo "Starting Reservation Service"
(cd reservations && docker-compose up -d)

echo "Starting Payment Service"
(cd payment && make build && make mount_detach)

echo "Starting IPTF Service"
(cd iptf && mvn -Dmaven.test.skip=true package && docker-compose up -d)

echo "Starting Composer Service"
(cd composer && docker-compose up -d)
