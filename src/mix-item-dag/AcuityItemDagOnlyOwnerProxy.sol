pragma solidity ^0.6.7;

import "./AcuityItemDagOnlyOwner.sol";


contract AcuityItemDagOnlyOwnerProxy {

    AcuityItemDagOnlyOwner mixItemDagOnlyOwner;

    constructor (AcuityItemDagOnlyOwner _mixItemDagOnlyOwner) public {
        mixItemDagOnlyOwner = _mixItemDagOnlyOwner;
    }

    function addChild(bytes32 itemId, AcuityItemStoreInterface childItemStore, bytes32 childNonce) external {
        mixItemDagOnlyOwner.addChild(itemId, childItemStore, childNonce);
    }

}
