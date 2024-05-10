# Bundlers Test Results Dashboard

This repo runs the `bundler-spec-test` against a list of bundlers, and show the results.

The result page is in: https://www.erc4337.io/bundlers

Or https://bundler-test-results.erc4337.io/

Each bundler to run has a folder and yml file [./bundlers](./bundlers) folder

## To add a bundler to the list:

- Check the [Prerequisites](#prerequisites), below
- Clone this repo.
- Create a bundler folder and `yml` in the "bundlers" folder.
- if local files are needed, they should be placed in that bundler-specific folder, and referenced through `volumes:`
- the folder may contain `.env` for bundler-specific environment params (in addition to the global `./runbundler/.env`)
- it should reference the node running in `ETH_NODE_URL`, using entrypoint at `ENTRYPOINT` address
- see the `runbundler/.env` for global settings, like `FUND` for funded addresses.
- The bundler-specific RPC calls (eth_ and debug_) should be exposed on `BUNDLER_URL`
- To test bundler startup script:
  * `./runbundler/runbundler.sh {./bundlers/aabundler/aabundler.yml} start` - start the bundler (along with node, and deployed contract)
  * `down` - stop all docker images.
  * (or any other docker-compose command, such as `logs`)

- Create a PR to add your launcher to the list.
- The result page (above) will get updated.

## Running just a single bundler tests:
To test a single bundler (instead of running all tests):

`./runall.sh {yml} {pytest params}`
- **yml** - the full path to a bundler yml file (e.g. `./bundlers/aabundler/aabundler.yml`)
- **pytest params** - parameters to pass down to pytest. e.g. "`-k GASP`" or "`-x`"



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
