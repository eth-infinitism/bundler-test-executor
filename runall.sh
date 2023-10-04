#!/bin/bash -e
root=`realpath \`dirname $0\``

BUILD=$root/build
OUT=$BUILD/out
test -d bundler-spec-tests || git clone https://github.com/eth-infinitism/bundler-spec-tests.git

BUNDLERS="`pwd`/bundlers/*/*yml"
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

basename=`basename -s .yml $bundler`
outxml=$OUT/$basename.xml
outjson=$OUT/$basename.json
outraw=$OUT/$basename.txt
outlogs=$OUT/$basename.log

#todo: better name to extract the name from the yml file?
#from actual image, can do docker inspect {imageid} | jq .Config.Env
name=`sed -ne 's/ *NAME=[ "]*\([^"]*\)"*/\1/p' $bundler`

test -z $name && name=$basename

echo "Running bundler $bundler, name=$name" > $outraw
if $root/runbundler/runbundler.sh $bundler start; then
  OPTIONS="
	--junit-xml $outxml
	-o junit_logging=all -o junit_log_passing_tests=false
  "
  # --log-rpc
  pdm run test -o junit_suite_name="$name" $OPTIONS "$@" | tee -a $outraw
  test -r $outxml && xq . $outxml > $outjson
  $root/runbundler/runbundler.sh $bundler logs -t > $outlogs

fi

$root/runbundler/runbundler.sh $bundler down


done

ls $OUT > $OUT/index.txt

cd $root
cp -r html/* build/
find $OUT -type f
