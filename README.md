# Bundlers Spec Dashboard

This repo is a website for checking EIP-4337 bundlers compliance with the spec.

It runs the spec tests against each bundler, and shows the result in the generated status page.

To add a bundler to the list:

- Clone this repo.
- Create a launcher script in the "launchers" folder, that ends with ".sh"
- The script should run both bundler and node.
- The standard node RPC calls should be exposed as http://localhost:8545
- The bundler-specific RPC calls (eth_ and debug_) should be exposed on http://localhost:3000/rpc
- See the launcher script that uses "docker-compose" to start and stop the bundler (and geth)
- Create a PR to add this launcher to the list.
