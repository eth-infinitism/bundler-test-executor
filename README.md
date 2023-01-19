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
