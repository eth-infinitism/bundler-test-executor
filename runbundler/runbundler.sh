#!/bin/bash  -x
dir=`dirname $0`

function usage() {
cat <<EOF
usage: $0 {ymlfile|testfile} {start|stop|..}
  ymlfile -  a single bundler yml file. uses DCFILE="runbundler.yml"
  testfile - env file to define all launch env. params.
  cmd:
  	start (wait for wait-for-bundler task to exit)
  	any docker-compose command (e.g: up,start,down,logs)
  testfile expected env.vars:
    DCFILE - the docker-compose.yml file to use. defaults to run2bundlers.yml
    BUNDLER_YML - bundler-specific file for bootnode bundler
    BUNDLER2_YML - bundler-specific file for peer bundler
	ENVFILE, ENVFILE2 - extra env.vars used by above bundlers
EOF
exit 1 

}

file=$1
cmd=$2
shift
shift

test -z "$cmd" && usage

case "$file" in 
	*.yml)
		export DCFILE="$dir/runbundler.yml"
		export DCPARAMS="--env-file $dir/runbundler.env"
		ENVFILE=`dirname $BUNDLER_YML`/.env
		test -r $ENVFILE && DCPARAMS="$DCPARAMS --env-file $ENVFILE"
		export BUNDLER_YML=$file
		;;

	*.env)
		export DCFILE="$dir/run2bundlers.yml"
		export DCPARAMS="--env-file $dir/run2bundlers.env"
		source $file
		test -r "$ENVFILE" && DCPARAMS="$DCPARAMS --env-file $ENVFILE"
		test -r "$ENVFILE2" && DCPARAMS="$DCPARAMS --env-file $ENVFILE2"
		;;
	*)	usage ;;

esac

DC="docker-compose $DCPARAMS -f $dir/../empty.yml -f $DCFILE"
cmd=$cmd
case "$cmd" in 

	start) $DC run --rm wait-for-bundler ;;
	down) $DC down -t 1 ;;
	stop) $DC stop -t 1 ;;
	#execute misc docker-compose command
	*) $DC $cmd $* ;;

esac

