// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFConsumerBaseV2} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
 * @title A sample Raffle Contract
 * @author Patrick Collins (or even better, you own name)
 * @notice This contract is for creating a sample raffle
 * @dev It implements Chainlink VRFv2.5 and Chainlink Automation
 */



contract Raffle is VRFConsumerBaseV2Plus {   
    error Raffle_NotEnoughEthSent();
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;


    address immutable i_vrfCoordinator;

    event EnteredRaffle(uint256 indexed s_player);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32  callbackGaslimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_callbackGasLimit = callbackGaslimit;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        // i_vrfCoordinator = vrfCoordinator;
    }

    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH sent!");
        if (msg.value < i_entranceFee) revert Raffle_NotEnoughEthSent();
        s_players.push(payable(msg.sender));
    }

    function pickWinner() public{
        if ((block.timestamp - s_lastTimeStamp) < i_interval) revert();

        VRFV2PlusClient.RandomWordsRequest memory request =  VRFV2PlusClient.RandomWordsRequest({
                  keyHash: i_keyHash,
                  subId: i_subscriptionId,
                  requestConfirmations: REQUEST_CONFIRMATIONS,
                  callbackGasLimit: i_callbackGasLimit,
                  numWords: NUM_WORDS,
                  extraArgs: VRFV2PlusClient._argsToBytes(
                      // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                      VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                  )
              });

              uint256 requestID = s_vrfCoordinator.requestRandomWords(request);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {}
    
    function getEntranceFee() view public returns (uint256) {
        return i_entranceFee;
    }
}
