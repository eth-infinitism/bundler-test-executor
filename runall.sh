#!/bin/bash -xe
root=`cd \`dirname $0\`; pwd`

BUILD=$root/build
OUT=$BUILD/out
RAW=$BUILD/raw
#test -d bundler-spec-tests || git clone https://github.com/eth-infinitism/bundler-spec-tests.git -b modules-https
#cd bundler-spec-tests 
#git pull

#runall=1
if [ -n "$runall" ]; then
pdm install
pdm update-deps
fi


rm -rf $OUT $RAW
mkdir -p $OUT
mkdir -p $RAW

cd bundler-spec-tests

for launcher in ../launchers/*; do
#skip folders
test -d $launcher && continue

echo ====================================================================
echo ====== `basename $launcher`
echo ====================================================================

basename=`basename -s .sh $launcher`
outxml=$OUT/$basename.xml
outjson=$OUT/$basename.json
outraw=$RAW/$basename.txt

pdm run test --launcher-script=$launcher --junit-xml $outxml -k  GAS | tee $outraw
xq . $outxml > $outjson

cat $outjson

done

find $root/build
