if [ $# -ge 1 ] && [ $1 = "-b" ]; then
	 
	echo "Rebuilding Review Service"
	(cd reviewService && docker-compose build)

	echo "Rebuilding Reservation Service"
	(cd reservations && docker-compose build)

	echo "Rebuilding Payment Service"
	(cd payment && make build)

	echo "Rebuilding IPTF Service"
	(cd iptf && mvn -Dmaven.test.skip=true package && docker-compose build)

	echo "Rebuilding Composer Service"
	(cd composer && docker-compose build)

fi

echo "Starting Review Service"
(cd reviewService && docker-compose up -d)

echo "Starting Reservation Service"
(cd reservations && docker-compose up -d)

echo "Starting Payment Service"
(cd payment && docker-compose up -d)

echo "Starting IPTF Service"
(cd iptf && mvn -Dmaven.test.skip=true package && docker-compose up -d)

echo "Starting Composer Service"
(cd composer && docker-compose up -d)
