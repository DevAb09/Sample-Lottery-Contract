## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

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

# Raffle Smart Contract (Foundry)

A decentralized raffle (lottery) smart contract built with **Solidity** and **Foundry**, using **Chainlink VRF** for verifiable randomness and **Chainlink Automation** for automated execution.

---

## Current Progress

This project is currently in development.

### Completed
- Contract setup
- State variables
- Raffle state management using `enum`
- Basic structure for entering raffle

### In Progress
- Chainlink VRF integration (random winner selection)
- Automation (checkUpkeep / performUpkeep)

---

## Overview

This contract allows users to enter a raffle by sending ETH. After a fixed time interval, a random winner will be selected using Chainlink VRF and awarded the contract balance.

---

## Features (Planned)

- Enter raffle with ETH
- Automated winner selection
- Verifiable randomness (Chainlink VRF)
- Secure state management
- Fully tested with Foundry

---

## Tech Stack

- Solidity
- Foundry
- Chainlink VRF
- Chainlink Automation

---

## Project Structure
src/        
test/
script/

---

## Running Tests

```bash
forge test
```
## Build
forge build
>>>>>>> 382286491b087ed660096b3d27009f1e24de0eb6
