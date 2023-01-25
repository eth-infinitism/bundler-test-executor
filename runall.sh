#!/bin/bash -xe
root=`cd \`dirname $0\`; pwd`

BUILD=$root/build
OUT=$BUILD/out
RAW=$BUILD/raw
test -d bundler-spec-tests || git clone https://github.com/eth-infinitism/bundler-spec-tests.git

cd bundler-spec-tests 

#first time must runall.
test -d .venv || runall=1
if [ -n "$runall" ]; then
git pull
pdm install
pdm update-deps
fi


rm -rf $OUT $RAW
mkdir -p $OUT
mkdir -p $RAW

for launcher in ../launchers/*.sh; do
#skip folders
test -d $launcher && continue

echo ====================================================================
echo ====== `basename $launcher`
echo ====================================================================

basename=`basename -s .sh $launcher`
outxml=$OUT/$basename.xml
outjson=$OUT/$basename.json
outraw=$RAW/$basename.txt

name=`$launcher name`
pdm run test --launcher-script=$launcher -o junit_suite_name="$name"  --junit-xml $outxml "$@" | tee $outraw
xq . $outxml > $outjson

cat $outjson

done

#generate list of all files:
ls $OUT > $OUT/list.txt

cd $root
cp -r html/* build/
find build
