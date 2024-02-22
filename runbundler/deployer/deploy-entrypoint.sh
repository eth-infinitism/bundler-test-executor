#!/bin/sh -e

test -n "$VERBOSE" && set -x

dir=`dirname $0` 
#assume running from account-abstraction project dir, with hardhat artifacts
base=$dir
test -d $dir/artifacts || base=~/Downloads/account-abstraction
epDir=$base/artifacts/contracts/core/EntryPoint.sol
buildinfo=`jq < $epDir/EntryPoint.dbg.json -r .buildInfo`
#above is relative path
buildInfoPath=$epDir/$buildinfo
ep=`jq -r '.output.contracts[].EntryPoint.evm.bytecode.object | select(.!=null)' < $buildInfoPath`

if [ -n "$ENTRYPOINT" ]; then
  if [ `cast cs $ENTRYPOINT` != 0 ] ; then
    echo entryPoint $ENTRYPOINT already deployed.
    exit 0
  fi
fi

echo Deploying entrypoint at $ENTRYPOINT
salt=0x90d8084deab30c2a37c45e8d47f49f2f7965183cb6990a98943ef94940681de3
$dir/create2deployer.sh $ep $salt

if [ -n "$ENTRYPOINT" ]; then
  if [ `cast cs $ENTRYPOINT` == 0 ] ; then
    echo "fatal: deployer didn't deploy entryPoint $ENTRYPOINT"
    exit 1
  fi
fi
