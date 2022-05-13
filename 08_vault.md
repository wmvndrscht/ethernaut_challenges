# Vault

## Challenge Statement

Unlock the vault to pass the level!

## Analysis

To unlock the vault the unlock function needs to be called with the correct password. The password is a bytes32 private variable. While it's not possible to read a private variable from another contract, all information is public on a blockchain, therefore it's possible to read the variable. To do so we can index the storage using a web3.js call.


## Solution

password = web3.eth.getStorageAt('<target address>', 1)
password: 0x412076657279207374726f6e67207365637265742070617373776f7264203a29
contract.unlock(password)

## Moral

It's important to remember that marking a variable as private only prevents other contracts from accessing it. State variables marked as private and local variables are still publicly accessible.

To ensure that data is private, it needs to be encrypted before being put onto the blockchain. In this scenario, the decryption key should never be sent on-chain, as it will then be visible to anyone who looks for it. zk-SNARKs provide a way to determine whether someone possesses a secret parameter, without ever having to reveal the parameter.