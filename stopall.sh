docker stop $(docker ps -a -q)

if [ $1 = "-d" ]; then
	docker rm $(docker ps -a -q)
fi
