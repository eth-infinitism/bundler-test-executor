#!/bin/bash 
# Launcher script for the aa-bundler in Rust.

cd `dirname \`realpath $0\``
case $1 in

 name)
	echo "aa-bundler in Rust"
	;;

 start)
	docker-compose up -d
	cd ../../bundler-spec-tests/@account-abstraction && yarn deploy --network localhost
	;;
 stop)
 	docker-compose down -t 1
	;;

 *)
	echo "usage: $0 {start|stop|name}"
esac
