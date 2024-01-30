#!/bin/bash

test -n "$VERBOSE" && set -x

root=`realpath \`dirname $0\``

BUILD=$root/build
OUT=$BUILD/out
test -d bundler-spec-tests || git clone https://github.com/eth-infinitism/bundler-spec-tests.git

#by default, run all single-bundler configs
BUNDLERS=`ls $root/bundlers/*/*yml|grep -v p2p`

#if parameter is given, use it as single-bundler yml, or as testenv file
if [ -n "$1" -a -r "$1" ]; then
BUNDLERS=`realpath $1`
shift
fi

cd bundler-spec-tests

#first time must runall.
test -d .venv || runall=1
if [ -n "$runall" ]; then
git pull
pdm install
pdm update-deps
fi

rm -rf $OUT
mkdir -p $OUT

for bundler in $BUNDLERS; do

bundlerTitle=`echo $bundler|perl -pe "s@$root/?@@"`
echo ====================================================================
echo ====== $bundlerTitle
echo ====================================================================

basename=`basename -s .env \`basename -s .yml $bundler\``
outxml=$OUT/$basename.xml
outjson=$OUT/$basename.json
outraw=$OUT/$basename.txt
outlogs=$OUT/$basename.log

function getEnv {
  envFile=$1
  name=$2
  def=$3

  val=`sh -c "source $envFile; echo \\\$$name"`
  echo ${val:-$def}
}

#todo: better name to extract the name from the yml file?
#from actual image, can do docker inspect {imageid} | jq .Config.Env
name=`sed -ne 's/ *NAME=[ "]*\([^"]*\)"*/\1/p' $bundler`

test -z $name && name=$basename

echo "`date`: starting bundler $bundler, name=$name" | tee -a $outraw
if $root/runbundler/runbundler.sh $bundler pull-start; then

  echo "`date`: started bundler $bundler, name=$name" | tee -a $outraw

  case "$bundler" in
    *yml) PYTEST_FOLDER=`getEnv $root/runbundler/runbundler.env PYTEST_FOLDER tests/single` ;;
    *env) PYTEST_FOLDER=`getEnv $bundler PYTEST_FOLDER tests/p2p` ;;
  esac

  OPTIONS="
	--junit-xml $outxml
	-o junit_logging=all -o junit_log_passing_tests=false
  $PYTEST_FOLDER
  "
  # --log-rpc
  pdm run test -o junit_suite_name="$name" $OPTIONS "$@" | tee -a $outraw
  test -r $outxml && xq . $outxml > $outjson

fi

echo "`date`: done bundler $bundler, name=$name" | tee -a $outraw
$root/runbundler/runbundler.sh $bundler images | tee -a $outraw

$root/runbundler/runbundler.sh $bundler logs -t > $outlogs
$root/runbundler/runbundler.sh $bundler down


done

ls $OUT > $OUT/index.txt

cd $root
cp -r html/* build/
find $OUT -type f
