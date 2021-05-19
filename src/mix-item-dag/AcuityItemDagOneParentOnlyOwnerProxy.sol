pragma solidity ^0.6.7;

import "./AcuityItemDagOneParentOnlyOwner.sol";


contract AcuityItemDagOneParentOnlyOwnerProxy {

    AcuityItemDagOneParentOnlyOwner mixItemDagOneParentOnlyOwner;

    constructor (AcuityItemDagOneParentOnlyOwner _mixItemDagOneParentOnlyOwner) public {
        mixItemDagOneParentOnlyOwner = _mixItemDagOneParentOnlyOwner;
    }

    function addChild(bytes32 itemId, AcuityItemStoreInterface childItemStore, bytes32 childNonce) external {
        mixItemDagOneParentOnlyOwner.addChild(itemId, childItemStore, childNonce);
    }

}
