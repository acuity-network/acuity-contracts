pragma solidity ^0.6.6;

import "./MixItemDagOnlyOwner.sol";


contract MixItemDagOnlyOwnerProxy {

    MixItemDagOnlyOwner mixItemDagOnlyOwner;

    constructor (MixItemDagOnlyOwner _mixItemDagOnlyOwner) public {
        mixItemDagOnlyOwner = _mixItemDagOnlyOwner;
    }

    function addChild(bytes32 itemId, MixItemStoreInterface childItemStore, bytes32 childNonce) external {
        mixItemDagOnlyOwner.addChild(itemId, childItemStore, childNonce);
    }

}
