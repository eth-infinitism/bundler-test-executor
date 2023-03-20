#!/bin/bash 

cd `dirname \`realpath $0\``
case $1 in

 name)
	echo "Voltaire-Bundler"
	;;

 start)
	docker-compose up -d
	echo waiting for bundler to start
	../aabundler/waitForBundler http://localhost:3000/rpc
	cd ../../bundler-spec-tests/@account-abstraction && yarn deploy --network localhost
	;;
 stop)
 	docker-compose down -t 3
	;;

 *)
	echo "usage: $0 {start|stop|name}"
esac
