// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract GatekeeperOne {

  using SafeMath for uint256; // safemath defined for uint256 but not used in the rest of the contract!
  address public entrant;

  // first gate - required sender is not also the origin e.g contract does not call by itself
  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  // second gate - ensure gas is a multiple of 8191
  modifier gateTwo() {
    require(gasleft().mod(8191) == 0);
    _;
  }

  // third gate - input parameter - bytes8 = 64 bits
  // takes the top 16 bits of tx.origin
  // headecimal 0xF = 15 = binary(1111) = 4 bits
  // last 4 hex of tx.origin = 0xABCD
  // tx.origin = 256 bits
  // 0x8ff9|8ff9|6341|5673|3423|2932|2932|0b16|1234|ABCD
  // 64 LS bits
  // 2932|0b16|1234|ABCD
  // bytes8 version = 0x100000000000ABCD
  modifier gateThree(bytes8 _gateKey) {
      // 0000|69f9 == 0000|69f9
      require(uint32(_gateKey) == uint16(_gateKey), "GatekeeperOne: invalid gateThree part one");
      // 1000|0000|0000|69f9 != 0000|0000|0000|69f9
      require(uint32(_gateKey) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      // 0000|69f9 == 0000|69f9
      require(uint32(_gateKey) == uint16(tx.origin), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}