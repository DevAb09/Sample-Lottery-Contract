//SPDX License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";


contract DeployScript is Script {
    function run() public returns (Raffle, HelperConfig){
        return DeployRaffle();
    }

    function DeployRaffle() public returns (Raffle, HelperConfig){
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        vm.startBroadcast();
        Raffle raffle = new Raffle(
            config.entranceFee,
            config.interval,
            config.vrfCoordinator,
            config.gasLane,
            config.Gaslimit, // 500,000 gas
            uint32(config.subscriptionId)   
        );
        vm.stopBroadcast();

        return(raffle, helperConfig);
    }
}