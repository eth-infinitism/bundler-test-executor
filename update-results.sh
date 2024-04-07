#!/bin/bash -xe

resultrepo=https://github.com/eth-infinitism/bundler-test-results.git
root=`cd \`dirname $0\`;pwd`

if [[ -z "$1" || -d "$1" ]] ; then
  echo usage: $0 {out-results-clone-folder} [branch]
  echo "out folder is created."
  echo "(if branch (or GITHUB_REF) is set, the folder is also cloned from $resultrepo)"
  exit 1
fi

base=$root/$1
branch=$2

RUNS=$base/v07/runs
HIST=$base/v07/history

#for local testing. it is set by github action
GITHUB_REF=${GITHUB_REF:=`git symbolic-ref  HEAD`}

#starts with "refs/heads/{branchname}"
branch=${2:-`echo $GITHUB_REF | perl -pe 's@.*heads/@@'`}

rm -rf $base
mkdir -p $base

#pushing to the same branch in the results repo as this (ux) repo
test -n "$branch" && git clone --depth 1 $resultrepo -b $branch $base

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

mkdir -p $HIST
$root/create-history.sh $RUNS > $HIST/history.json
(echo -n 'testHistory=' ; cat $HIST/history.json) > $HIST/script-history.js

echo == summary of last run:
jq '.[keys|last] | values[] | {name,tests,errors,failures,time, timestamp}' $HIST/history.json || find $base
