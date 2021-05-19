pragma solidity ^0.6.7;

import "./AcuityItemDagOnlyOwner.sol";


contract AcuityItemDagOnlyOwnerProxy {

    AcuityItemDagOnlyOwner acuityItemDagOnlyOwner;

    constructor (AcuityItemDagOnlyOwner _acuityItemDagOnlyOwner) public {
        acuityItemDagOnlyOwner = _acuityItemDagOnlyOwner;
    }

    function addChild(bytes32 itemId, AcuityItemStoreInterface childItemStore, bytes32 childNonce) external {
        acuityItemDagOnlyOwner.addChild(itemId, childItemStore, childNonce);
    }

}
