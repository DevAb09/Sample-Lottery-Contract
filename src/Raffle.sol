// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;


import {VRFConsumerBaseV2} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";   

/**
 * @title A sample Raffle Contract
 * @author Abraham Douglas
 * @notice This contract is for creating a sample raffle
 * @dev It implements Chainlink VRFv2.0 and Chainlink Automation
 */


contract Raffle is VRFConsumerBaseV2 {
    error Raffle__NotEnoughtEth();
    error Raffle_RaffleStateNotOpen();
    error Raffle__TransferFailed();
    error Raffle__upKeepNeeded(uint256 balance, uint256 playerslength, uint256 raffleState);

        uint16 private constant REQUEST_CONFIRMATIONS = 3;
        uint32 private constant NUM_WORDS = 1; 
        
        
        address payable[] s_players;

        uint256 private immutable i_entranceFee;
        uint256 private immutable i_interval;
        VRFCoordinatorV2Interface private immutable i_vrfCoordinator;   
        bytes32 private immutable i_keyHash;
        uint64 private immutable i_subscriptionId;
        uint32  private immutable i_callbackGasLimit;

        uint256 private s_lastTimeStamp;
        uint256 private s_raffleState;
        address private s_recentWinner;
        uint256 public s_lastRequestId;   
    
    enum RaffleState{
        OPEN,
        CALCULATING
    }
     constructor(
           uint256 entranceFee,
           uint256 interval,
           address vrfCoordinator,
           bytes32 gasLane,
           uint64 subscriptionId,
           uint32  callbackGaslimit
         ) VRFConsumerBaseV2(vrfCoordinator) {
           i_entranceFee = entranceFee;
           i_interval = interval;
        
           i_callbackGasLimit = callbackGaslimit;
           i_keyHash = gasLane;
           i_subscriptionId = subscriptionId;

           s_lastTimeStamp = block.timestamp;
           s_raffleState = uint256(Raffle.RaffleState.OPEN);   
           i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);   
     }

    function enteredRaffle() external payable {
        if(msg.value < i_entranceFee) {
            revert Raffle__NotEnoughtEth();
        }
        s_players.push(payable(msg.sender));   
        s_raffleState = uint256(RaffleState.OPEN);
        if(s_raffleState != uint256(RaffleState.OPEN)) {
            revert Raffle_RaffleStateNotOpen();
        }
    }

    function checkUpKeep(bytes memory /*checkdata*/) public view returns(bool UpKeepNeeded, bytes memory /*performData*/) {
         bool timeHasPassed = (block.timestamp - s_lastTimeStamp) >= i_interval;
         bool isOpened = s_raffleState == uint256(RaffleState.OPEN);   
         bool hasBalance = address(this).balance > 0;
         bool hasPlayer = s_players.length > 0;        
         UpKeepNeeded = timeHasPassed && isOpened && hasBalance && hasPlayer;
         return (UpKeepNeeded, "");
    }

    function pickWinner() public {
        (bool UpKeepNeeded,) = checkUpKeep("");
        if(!UpKeepNeeded) {revert Raffle__upKeepNeeded(address(this).balance, s_players.length, uint256(s_raffleState));}

        s_raffleState = uint256(RaffleState.CALCULATING);

    uint256 requestId = i_vrfCoordinator.requestRandomWords(
        i_keyHash,
        i_subscriptionId,
        REQUEST_CONFIRMATIONS,
        i_callbackGasLimit,
        NUM_WORDS
        );
    s_lastRequestId = requestId;
}   


    function fulfillRandomWords(uint256 /*requestId*/, uint256[] memory randomWords) internal override{
        uint256 index = randomWords[0] % s_players.length;
        address RecentWinner = s_players[index];
        s_recentWinner = RecentWinner;
       
        s_raffleState = uint256(RaffleState.OPEN);
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;

        (bool success,) = RecentWinner.call{value: address(this).balance}("");
           if (!success){
               revert Raffle__TransferFailed();
           }
    }

    function getEnteranceFee() public pure returns(uint256 i_enteranceFee){
        return i_enteranceFee;
    }
}