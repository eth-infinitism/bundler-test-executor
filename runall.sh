#!/bin/bash -e
root=`cd \`dirname $0\`; pwd`

BUILD=$root/build
OUT=$BUILD/out
test -d bundler-spec-tests || git clone https://github.com/eth-infinitism/bundler-spec-tests.git

LAUNCHERS="`pwd`/launchers/*.sh"
if [ -n "$1" -a -r "$1" ]; then
LAUNCHERS=`pwd`/$1
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

for launcher in $LAUNCHERS; do 

#skip folders
test -d $launcher && continue

echo ====================================================================
echo ====== `basename $launcher`
echo ====================================================================

basename=`basename -s .sh $launcher`
outxml=$OUT/$basename.xml
outjson=$OUT/$basename.json
outraw=$OUT/$basename.txt

name=`$launcher name`
echo "Running launcher $launcher, name=$name" > $outraw
OPTIONS="--launcher-script=$launcher --junit-xml $outxml"
OPTIONS="$OPTIONS -o junit_logging=all -o junit_log_passing_tests=false"
# --log-rpc
pdm run test -o junit_suite_name="$name" $OPTIONS "$@" | tee -a $outraw
xq . $outxml > $outjson

cat $outjson

done

ls $OUT > $OUT/index.txt

cd $root
cp -r html/* build/
find build
