#!/bin/bash 
#launcher script for the AA reference bundler.
# copied from https://github.com/eth-infinitism/bundler/blob/main/dockers/test/aabundler-launcher.sh

cd `dirname \`realpath $0\``
case $1 in

 name)
	echo "AA Reference Bundler/0.4.0"
	;;

 start)
	docker-compose up -d
	while ! [[  `curl 2>/dev/null  -X POST http://localhost:3000/rpc` =~ error ]]; do sleep 1 ; done
	;;
 stop)
 	docker-compose down
	;;

 *)
	echo "usage: $0 {start|stop|name}"
esac
