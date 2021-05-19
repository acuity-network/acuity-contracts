pragma solidity ^0.6.7;

import "./AcuityItemDagOneParentOnlyOwner.sol";


contract AcuityItemDagOneParentOnlyOwnerProxy {

    AcuityItemDagOneParentOnlyOwner acuityItemDagOneParentOnlyOwner;

    constructor (AcuityItemDagOneParentOnlyOwner _acuityItemDagOneParentOnlyOwner) public {
        acuityItemDagOneParentOnlyOwner = _acuityItemDagOneParentOnlyOwner;
    }

    function addChild(bytes32 itemId, AcuityItemStoreInterface childItemStore, bytes32 childNonce) external {
        acuityItemDagOneParentOnlyOwner.addChild(itemId, childItemStore, childNonce);
    }

}
