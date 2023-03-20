#!/bin/bash 
#launcher script for the AA reference bundler.
# copied from https://github.com/eth-infinitism/bundler/blob/main/dockers/test/aabundler-launcher.sh

export TAG=0.5.0
cd `dirname \`realpath $0\``
case $1 in

 name)
	echo "AA-Reference-Bundler/$TAG"
	;;

 start)
	docker-compose up -d
	echo waiting for bundler to start
	./waitForBundler http://localhost:3000/rpc
	;;
 stop)
 	docker-compose down -t 0
	;;

 *)
	echo "usage: $0 {start|stop|name}"
esac
