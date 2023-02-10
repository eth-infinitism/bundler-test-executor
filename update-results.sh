#!/bin/bash -xe

if [ -z "$1" -o "$1" == "." -o "$1" == ".." ]; 
then
echo usage: $0 {results-clone-folder}
exit 1
fi

env

GITHUB_REF=${GITHUB_REF:=`git symbolic-ref  HEAD`}

#starts with "refs/heads/{branchname}"
branch=`echo $GITHUB_REF | perl -pe 's@.*/@@'`

base=`pwd`/$1

#pushing to the same branch in the results repo as this (ux) repo
rm -rf $base
git clone --depth 1 https://github.com/eth-infinitism/bundler-test-results.git -b $branch $base
ts=`date +%Y%m%d/%H%M%S`
folder=$base/runs/$ts
mkdir -p $folder
cp build/out/* $folder
cp -r html/ $folder
ls -p $folder > $folder/index.txt
cd $base/runs
ln -nsf $ts latest
ls -p > index.txt
find . > all.txt

