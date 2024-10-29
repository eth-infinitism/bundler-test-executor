#!/bin/bash 

test -n "$VERBOSE" && set -x

dir=`dirname $0`
root=`cd $dir/.. ; pwd`

function usage() {
cat <<EOF
usage: $0 {ymlfile|testfile} {start|stop|..}
  ymlfile -  a single bundler yml file. uses DCFILE="runbundler.yml"
  testfile - env file to define all launch env. params.
  cmd:
  	start (wait for wait-all task to complete)
  	any docker-compose command (e.g: up,start,down,logs)
  testfile expected env.vars:
    DCFILE - the docker-compose.yml file to use. defaults to run2bundlers.yml
    BUNDLER_YML - bundler-specific file for bootnode bundler
    BUNDLER2_YML - bundler-specific file for peer bundler
	ENVFILE, ENVFILE2 - extra env.vars used by above bundlers
EOF
exit 1 

}

#collect envfiles into TMPENV (docker-compose v1.x can get only a single env file..)
TMPENV=/tmp/tmp.env

function docker-compose1 {
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $root:$root -v $TMPENV:$TMPENV -w="$PWD" docker:24-cli compose "$@"
}

file=`realpath $1`
cmd=$2
shift
shift

test -z "$cmd" && usage

case "$file" in 
	*.yml)
		export DCFILE="$dir/runbundler.yml"
		cat $dir/runbundler.env > $TMPENV
		export DCPARAMS="--env-file $TMPENV"
		echo BUNDLER_YML=$file >> $TMPENV
		envfile1=`dirname $file`/.env
		ENVFILE=`cd $root; realpath $envfile1 2> /dev/null`
		test -r "$ENVFILE" && cat $ENVFILE >> $TMPENV
		;;

	*.env)
		export DCFILE="$dir/run2bundlers.yml"
		cat $dir/run2bundlers.env > $TMPENV
		export DCPARAMS="--env-file $TMPENV"
		source $file
		test -n "$ENVFILE" && test -r "$root/$ENVFILE" && cat $root/$ENVFILE >> $TMPENV
		test -n "$ENVFILE2" && test -r "$root/$ENVFILE2" && cat $root/$ENVFILE >> $TMPENV
		;;
	*)	usage ;;

esac

DC="docker compose $DCPARAMS -f $root/empty.yml -f $DCFILE"
cmd=$cmd
case "$cmd" in 

	start) $DC run --rm wait-all ;;
	pull-start) $DC pull --quiet && $DC build && $DC config|grep image && $DC run --rm wait-all ;; 
	down) $DC down -t 1 ;;
	stop) $DC stop -t 1 ;;
	#execute misc docker-compose command
	*) $DC $cmd $* ;;

esac

