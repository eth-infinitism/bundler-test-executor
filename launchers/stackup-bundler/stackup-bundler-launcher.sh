#!/bin/bash 

cd `dirname \`realpath $0\``
case $1 in

 name)
	echo "Stackup Bundler"
	;;

 start)
	docker-compose up -d
	(cd ../../bundler-spec-tests/@account-abstraction && yarn deploy --network localhost)
	;;
 stop)
 	docker-compose down
	;;

 *)
	echo "usage: $0 {start|stop|name}"
esac
