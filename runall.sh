#!/bin/bash -xe
root=`cd \`dirname $0\`; pwd`

BUILD=$root/build
OUT=$BUILD/out
test -d bundler-spec-tests || git clone https://github.com/eth-infinitism/bundler-spec-tests.git -b modules-https
cd bundler-spec-tests 
git pull

runall=1
if [ -n "$runall" ]; then
pdm install
pdm update-deps
fi


rm -rf $OUT
mkdir -p $OUT

for launcher in ../launchers/*; do
#skip folders
test -d $launcher && continue

echo ====================================================================
echo ====== `basename $launcher`
echo ====================================================================

outxml=$OUT/`basename -s .sh $launcher`.xml
outjson=$OUT/`basename -s .sh $launcher`.json
pdm run test --launcher-script=$launcher --junit-xml $outxml -k  GAS
#todo: convert xml to json...

done
