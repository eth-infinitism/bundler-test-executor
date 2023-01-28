#!/bin/bash -xe
root=`cd \`dirname $0\`; pwd`

BUILD=$root/build
OUT=$BUILD/out
test -d bundler-spec-tests || git clone https://github.com/eth-infinitism/bundler-spec-tests.git

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

for launcher in ../launchers/*.sh; do
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
pdm run test --launcher-script=$launcher -o junit_suite_name="$name"  --junit-xml $outxml "$@" | tee -a $outraw
xq . $outxml > $outjson

cat $outjson

done

ls $OUT > $OUT/index.txt

cd $root
cp -r html/* build/
find build
