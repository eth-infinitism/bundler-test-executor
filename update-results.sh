#!/bin/bash -xe
root=`cd \`dirname $0\`;pwd`

if [[ -z "$1" || -d "$1" ]] ; then
  echo usage: $0 {out-results-clone-folder}
  exit 1
fi

base=$root/$1

RUNS=$base/runs
HIST=$base/history

rm -rf $base
mkdir -p $base

#for local testing. it is set by github action
#GITHUB_REF=${GITHUB_REF:=`git symbolic-ref  HEAD`}

if [ -n "$GITHUB_REF" ]; then

#starts with "refs/heads/{branchname}"
branch=`echo $GITHUB_REF | perl -pe 's@.*/@@'`

#pushing to the same branch in the results repo as this (ux) repo
git clone --depth 1 https://github.com/eth-infinitism/bundler-test-results.git -b $branch $base

fi

ts=`date +%Y%m%d/%H%M%S`
folder=$RUNS/$ts
mkdir -p $folder
cp build/out/* $folder
cp -r html/ $folder
ls -p $folder > $folder/index.txt
cd $RUNS
ln -nsf $ts latest
ls -p > index.txt
find . > all.txt

$root/create-history.sh $RUNS > $HIST/history.json
(echo -n 'testHistory=' ; cat $HIST/history.json) > $HIST/script-history.js
