echo "Starting Review Service"
(cd reviewService && docker-composer up -d)

echo "Starting Reservation Service"
(cd reservations && docker-composer up -d)

echo "Starting Payment Service"
(cd payment && make build && make mount_detach)

echo "Starting IPTF Service"
(cd iptf && mvn package && docker-composer up -d)

echo "Starting Composer Service"
(cd composer && docker-composer up -d)
