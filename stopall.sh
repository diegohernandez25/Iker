docker stop $(docker ps -a -q)

if [ $# -ge 1 ] && [ $1 = "-d" ]; then
	docker rm $(docker ps -a -q)
fi
