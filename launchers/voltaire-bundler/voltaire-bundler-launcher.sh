#!/bin/bash 

cd `dirname \`realpath $0\``
case $1 in

 name)
	echo "Voltaire-Bundler"
	;;

 start)
	docker-compose up -d
	echo waiting for bundler to start
	while ! [[  `curl -X POST http://localhost:3000/rpc` =~ error ]]; do echo waiting for bundler; sleep 3 ; done
	geth --exec 'loadScript("deploy.js")' attach http://0.0.0.0:8545
	cd ../../bundler-spec-tests/@account-abstraction && yarn deploy --network localhost
	;;
 stop)
 	docker-compose down -t 0
	;;

 *)
	echo "usage: $0 {start|stop|name}"
esac
