pragma solidity ^0.6.6;

import "./MixItemDagOneParentOnlyOwner.sol";


contract MixItemDagOneParentOnlyOwnerProxy {

    MixItemDagOneParentOnlyOwner mixItemDagOneParentOnlyOwner;

    constructor (MixItemDagOneParentOnlyOwner _mixItemDagOneParentOnlyOwner) public {
        mixItemDagOneParentOnlyOwner = _mixItemDagOneParentOnlyOwner;
    }

    function addChild(bytes32 itemId, MixItemStoreInterface childItemStore, bytes32 childNonce) external {
        mixItemDagOneParentOnlyOwner.addChild(itemId, childItemStore, childNonce);
    }

}
