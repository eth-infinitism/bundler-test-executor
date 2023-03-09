#!/bin/bash 

cd `dirname \`realpath $0\``
case $1 in

 name)
	echo "Stackup Bundler"
	;;

 start)
	docker-compose up -d
	echo "deploying EntryPoint..."
	(cd ../../bundler-spec-tests/@account-abstraction && yarn deploy --network localhost)
	while true; do
		curl --fail http://localhost:3000/ping && break
		echo "waiting for bundler..."
		sleep 3
	done
	;;
 stop)
 	docker-compose down -t 0
	;;

 *)
	echo "usage: $0 {start|stop|name}"
esac
