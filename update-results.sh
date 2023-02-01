#!/bin/bash -xe

if [ -z "$1" ]; 
then
echo usage: $0 {results-clone-folder}
exit 1
fi

env
base=`pwd`/$1
rm -rf $base
git clone --depth 1 https://github.com/eth-infinitism/bundler-test-results.git $base
ts=`date +%Y%m%d/%H%M%S`
folder=$base/runs/$ts
mkdir -p $folder
cp build/out/* $folder
ls -p $folder > $folder/index.txt
cd $base/runs
ln -nsf $ts latest
ls -p > index.txt
find . > all.txt

