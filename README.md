# Bundlers Test Results Dashboard

This repo runs the `bundler-spec-test` against a list of bundlers, and show the results.

The result page is in: https://www.erc4337.io/bundlers

Or https://bundler-test-results.eip4337.com/

Each bundler to run has a shell script in the [./launchers](./launchers) folder

## To add a bundler to the list:

- Check the [Prerequisites](#prerequisites), below
- Clone this repo.
- Create a launcher script in the "launchers" folder, that ends with ".sh"
- The script should run both bundler and node.
- The standard node RPC calls should be exposed as http://localhost:8545
- The bundler-specific RPC calls (eth_ and debug_) should be exposed on http://localhost:3000/rpc
- See the launcher script for the reference bundler [aabundler-launcher.sh](https://github.com/eth-infinitism/bundlers-test-results/blob/master/launchers/aabundler/aabundler-launcher.sh), that uses "docker-compose" to start and stop the bundler (and geth)
- To run the tests locally, run the `./runall.sh` script
- Create a PR to add your launcher to the list.
- The result page (above) will get updated.

## Running just a single bundler tests:
To test a single bundler (instead of running all tests):

`./runall.sh {script} {pytest params}`
- **script** - the full path to the script (e.g. `./launchers/aabundler-launcher.sh`)
- **pytest params** - parameters to pass down to pytest. e.g. "`-k GAS`" or "`-x`"



## Prerequisites


### docker-compose v2

Make sure you have docker-compose version 2

On Ubuntu: install from [here](https://docs.docker.com/compose/install/linux/#install-the-plugin-manually)
 (Ubuntu 20.04 includes an older version of docker-compose)

### nodejs 
Make sure to install nodejs "v14.x || v16.x || v18.x"
(The script are known to fail with nodejs v19 or v20)

You can use [NVM (Node Version Manager)](https://github.com/nvm-sh/nvm/blob/master/README.md) to manage different versions of node.

### yarn

On Ubuntu, the `yarn` binary from the `cmdtest` package may interfere with the `yarn` JS package manager.
This may lead to errors such as the following

```
ERROR: There are no scenarios; must have at least one.
```

It is recommended to install the correct `yarn` package manager as follows:

```
$ curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
$ echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
$ sudo apt update
$ sudo apt install yarn
```
