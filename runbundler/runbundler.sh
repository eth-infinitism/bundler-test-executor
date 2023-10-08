#!/bin/bash
dir=`dirname $0`

if [ -z "$2" ] ; then
       echo usage: "$0 {ymlfile} {start|stop|..}"
       exit 1 
fi

DC="docker-compose -f $dir/runbundler.yml"
export BUNDLER_YML=`realpath $1`
ENVFILE=`dirname $BUNDLER_YML`/.env
if [ -r $ENVFILE ] ; then
	export `grep -v '#' $ENVFILE`
fi

cmd=$2
shift
shift
case "$cmd" in 

	start) $DC run --rm wait-for-bundler ;;
        down) $DC down -t 1 ;;
	stop) $DC stop -t 1 ;;
	#execute misc docker-compose command
	*) $DC $cmd $* ;;

esac

