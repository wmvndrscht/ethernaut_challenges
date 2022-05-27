// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract King {

  address payable king; // address can receive eth
  uint public prize;
  address payable public owner; // owner can receive eth

  constructor() public payable { // payable allows a function to receive ether while being called 
    owner = msg.sender;
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    king.transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address payable) {
    return king;
  }
}