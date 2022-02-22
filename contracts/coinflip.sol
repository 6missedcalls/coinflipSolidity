//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

contract coinflip {
    using SafeMath for uint256;

    uint256 public constant minBet = 0.01 ether;
    uint256 public constant maxBet = 1000 ether;
    mapping(address => uint256) public totalWins;
    mapping(address => uint256) public totalLoss;
    mapping(address => uint256) public totalBets;
    mapping(address => uint256) public balances;

    event gameWon(address player, uint256 amount);
    event gameLost(address player, uint256 amount);

    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.number, block.timestamp, block.gaslimit, block.coinbase)));
    }

    function flipCoin() public payable {
        require(msg.value >= minBet);
        require(msg.value <= maxBet);

        uint256 bet = msg.value;
        uint256 randomNumber = random();
        uint256 randomNumberFlipped = randomNumber % 2;
        console.log("randomNumberFlipped: ", randomNumberFlipped);

        if (randomNumberFlipped == 0) {
            balances[msg.sender] += bet * 2;
            totalWins[msg.sender] += 1;
            console.log("You won!");
            emit gameWon(msg.sender, bet * 2);
        } if (randomNumberFlipped == 1) {
            balances[msg.sender] -= bet;
            totalLoss[msg.sender] += 1;
            console.log("You lost!");
            emit gameLost(msg.sender, bet);
        }
        totalBets[msg.sender] += 1;
    }

    // add address parameter and switch msg.sender to that address

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function getTotalWins() public view returns (uint256) {
        return totalWins[msg.sender];
    }

    function getTotalLosses() public view returns (uint256) {
        return totalLoss[msg.sender];
    }

    function getTotalBets(address _player) public view returns (uint256) {
        return totalBets[_player];
    }

}