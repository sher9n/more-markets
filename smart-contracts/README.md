## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```


### How to deploy contracts

before running scripts fill the `.env` and run:

`source .env`

deploy on sepolia:

`forge script --chain sepolia script/Deploy.s.sol:DeployMarketContracts --rpc-url $SEPOLIA_RPC_URL --broadcast -vvvv`

deploy on flow:

`forge script --chain flow script/Deploy.s.sol:DeployMarketContracts --rpc-url $FLOW_RPC_URL --broadcast --slow -vvvv`

add `--verify` to verify the contracts

use `--slow` in case of using flow public RPC, otherwise txs fails during the deployment.

deploy vaults factory 

`forge script --chain 545 script/DeployVaults.s.sol:DeployVaults --rpc-url $FLOW_RPC_URL --broadcast --slow -vvvv`


## Creating new market contract

`forge script --chain flow script/CreateNewMarket.s.sol:CreateNewMarket --rpc-url $FLOW_RPC_URL --broadcast --slow -vvvv`

script to retrive information about existing markets

`forge script --chain 545 script/getMarketsData.s.sol:getMarketsData --rpc-url $FLOW_RPC_URL --broadcast --slow -vvvv`

script to call owner setters on the Markets contract

forge script --chain 545 script/ownerSettersMarkets.s.sol:ownerSettersMarkets --rpc-url $FLOW_RPC_URL --broadcast --slow -vvvv