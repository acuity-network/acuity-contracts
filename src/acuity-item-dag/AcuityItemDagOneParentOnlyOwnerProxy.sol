// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;

import "./AcuityItemDagOneParentOnlyOwner.sol";


contract AcuityItemDagOneParentOnlyOwnerProxy {

    AcuityItemDagOneParentOnlyOwner acuityItemDagOneParentOnlyOwner;

    constructor (AcuityItemDagOneParentOnlyOwner _acuityItemDagOneParentOnlyOwner) {
        acuityItemDagOneParentOnlyOwner = _acuityItemDagOneParentOnlyOwner;
    }

    function addChild(bytes32 itemId, AcuityItemStoreInterface childItemStore, bytes32 childNonce) external {
        acuityItemDagOneParentOnlyOwner.addChild(itemId, childItemStore, childNonce);
    }

}
