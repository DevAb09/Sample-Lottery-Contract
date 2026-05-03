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
Build
Bash
forge build
