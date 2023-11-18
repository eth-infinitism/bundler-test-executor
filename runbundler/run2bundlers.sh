#!/bin/bash -e

test -n "$VERBOSE" && set -x

dir=`dirname $0`

if [ -z "$2" ] ; then
       echo usage: "$0 {bootyml} {start|stop|..}"
       exit 1 
fi

DC="docker-compose --env-file $dir/run2bundlers.env -f $dir/run2bundlers.yml"

export BUNDLER_YML=`realpath $1`
export BUNDLER2_YML=`realpath $2`
ENVFILE=`dirname $BUNDLER_YML`/.env
if [ -r $ENVFILE ] ; then
	export `grep -v '#' $ENVFILE`
fi
#env for bundler2 ?

cmd=$3
shift
shift
shift
case "$cmd" in 

	start) $DC run --rm wait-all ;;
        down) $DC down -t 1 ;;
	stop) $DC stop -t 1 ;;
	#execute misc docker-compose command
	*) $DC $cmd $* ;;

esac

