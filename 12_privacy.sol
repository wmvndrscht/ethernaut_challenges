// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


// Goal is to unlock the contract

// The private data is stored in the contract, can we access the right piece of data?
// e.g web3.eth.getStorageAt('<target address>', 1)
// slot 4 seems to hold the bytes32 data we need which is then cast down to 16 bytes
// key_32 = web3.eth.getStorageAt('0x9E829A37115350C2F754d8A6577c2Ec8abf940Cb', 5)
// =d51be7a7185442e39eb1e5bd3b462b440c4a6b0f6ac15dfe358adfc2627e7907
// take MS 16 bytes = 32 hex chars
// python: x = ..; x[:32]
// key = 0xd51be7a7185442e39eb1e5bd3b462b44
// contract.unlock('0xd51be7a7185442e39eb1e5bd3b462b44')

contract Privacy {

  bool public locked = true; // slot 0
  uint256 public ID = block.timestamp; // IGNORE: as constant uints are not stored in storage
  uint8 private flattening = 10; // slot 1
  uint8 private denomination = 255; // slot 1
  uint16 private awkwardness = uint16(now); //slot 1
  bytes32[3] private data; // slot 2,3,4 - [0,1,2]

  constructor(bytes32[3] memory _data) public {
    data = _data;
  }
  
  function unlock(bytes16 _key) public {
    require(_key == bytes16(data[2]));
    locked = false;
  }

}