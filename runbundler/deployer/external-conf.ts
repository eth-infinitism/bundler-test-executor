//use with "ETH_RPC_URL=... hardhat --config external-conf.ts"
//force network "external", which uses default test mnemonic, and ETH_RPC_URL
import conf from './hardhat.config.ts'
const url = process.env.ETH_RPC_URL 
if (url==null) throw Error("Missing ETH_RPC_URL")

conf.networks.external = { ...conf.networks.proxy, url }
conf.defaultNetwork = 'external'

export default conf
