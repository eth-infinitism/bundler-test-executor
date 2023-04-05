# Pre-requisites

The following are required by the bundler test executor (tested on Ubuntu 20.04)

## docker-compose v2

Please install manually as per instructions [here][1]. This is because the upstream docker debian repository for Ubuntu 20.04 installs v1 that is incompatible with docker compose configuration files found here.

## nodejs v14.x || v16.x || v18.x

Some Ubuntu versions (e.g., 20.04) pull in a later (19.x) version of nodejs that is incompatible with hardhat v2.12.4.
You may encounter errors such as the following

```
$ pdm install && pdm update-deps
...
error hardhat@2.12.4: The engine "node" is incompatible with this module. Expected version "^14.0.0 || ^16.0.0 || ^18.0.0". Got "19.8.1"
error Found incompatible module.
```

It is therefore recommended to install an older version of nodejs (e.g., 18.x).

## cmdtest package

The `yarn` binary from the `cmdtest` package may interfere with the `yarn` JS package manager.
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

# Bundlers Test Results Dashboard

This repo runs the `bundler-spec-test` against a list of bundlers, and show the results.

The result page is in: https://bundler-test-results.eip4337.com/

To add a bundler to the list:

- Clone this repo.
- Create a launcher script in the "launchers" folder, that ends with ".sh"
- The script should run both bundler and node.
- The standard node RPC calls should be exposed as http://localhost:8545
- The bundler-specific RPC calls (eth_ and debug_) should be exposed on http://localhost:3000/rpc
- See the launcher script for the reference bundler [aabundler-launcher.sh](https://github.com/eth-infinitism/bundlers-test-results/blob/master/launchers/aabundler/aabundler-launcher.sh), that uses "docker-compose" to start and stop the bundler (and geth)
- To run the tests locally, run the `./runall.sh` script
- Create a PR to add your launcher to the list.
- The result page (above) will get updated.

[1]: https://docs.docker.com/compose/install/linux/#install-the-plugin-manually
