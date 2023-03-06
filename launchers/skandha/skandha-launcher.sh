#!/bin/bash 

cd `dirname \`realpath $0\``
case $1 in

 name)
	echo "Skandha Bundler"
	;;

 start)
	docker-compose up -d
	echo "deploying EntryPoint..."
	(cd ../../bundler-spec-tests/@account-abstraction && yarn deploy --network localhost)
	echo waiting for bundler to start
	#while ! [[  `curl 2>/dev/null  -X POST http://localhost:3000/rpc` =~ error ]]; do sleep 1 ; done
	while ! [[  `curl -X POST http://localhost:3000/rpc` =~ error ]]; do echo waiting for bundler; sleep 3 ; done
	;;
 stop)
 	docker-compose down
	;;

 *)
	echo "usage: $0 {start|stop|name}"
esac
