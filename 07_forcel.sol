// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Kill {

    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function sendMoney() public payable {
    }

    function destroySmartContract(address payable _to) public {
        selfdestruct(_to);
    }

}