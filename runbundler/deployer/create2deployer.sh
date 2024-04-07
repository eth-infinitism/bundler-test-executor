#!/bin/sh -e
test -n "$VERBOSE" && set -x

test -z "$1" && cat <<EOF && exit 1
usage: $0 {constructor} [salt]
 first, the script deploy the create2 deployer (if not already deployed)
 constructor - create2 constructor code
 salt - or defaults to zero. mapped with to-uint256

sender:
- CAST_FROM is added to the "cast send" . 
- defaults to "--unlocked --from \`cast rpc eth_accounts|jq -r .[0]\`"
- can be replaced with "--private-key xxx" or "--mnemonic" or even "--ledger"
EOF

#when launched as-is, just deploy the deployer.
#when launched with "calldata", make a call to the deployer, to deploy that calldata


#arachnid's deployer: https://github.com/Arachnid/deterministic-deployment-proxy
deployerAddress=0x4e59b44847b379578588920ca78fbf26c0b4956c
deployerDeploymentTransaction=0xf8a58085174876e800830186a08080b853604580600e600039806000f350fe7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe03601600081602082378035828234f58015156039578182fd5b8082525050506014600cf31ba02222222222222222222222222222222222222222222222222222222222222222a02222222222222222222222222222222222222222222222222222222222222222
factoryDeployer=0x3fab184622dc19b6109349b94811493bf2a45362
#100000 gaslimit * 100 gwei
deploymentPrice=`cast to-wei 10000000 gwei`

if [ -z "$CAST_FROM" ]; then
  funder=`cast rpc eth_accounts |jq -r .[0]`
  CAST_FROM="--unlocked --from $funder"
fi

if [ `cast cs $deployerAddress` == 0 ]; then

  cast send --async $CAST_FROM $factoryDeployer --value $deploymentPrice > /dev/null
  cast publish --async $deployerDeploymentTransaction > /dev/null
fi

salt=${2:-0}
saltBytes=`cast to-uint256 $salt`
ctr=`cast concat-hex $saltBytes $1`
echo deploying:
#cast call $deployerAddress $ctr
cast send --async $CAST_FROM $deployerAddress $ctr > /dev/null

