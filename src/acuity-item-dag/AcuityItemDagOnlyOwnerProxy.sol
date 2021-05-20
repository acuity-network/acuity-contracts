// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "./AcuityItemDagOnlyOwner.sol";


contract AcuityItemDagOnlyOwnerProxy {

    AcuityItemDagOnlyOwner acuityItemDagOnlyOwner;

    constructor (AcuityItemDagOnlyOwner _acuityItemDagOnlyOwner) {
        acuityItemDagOnlyOwner = _acuityItemDagOnlyOwner;
    }

    function addChild(bytes32 itemId, AcuityItemStoreInterface childItemStore, bytes32 childNonce) external {
        acuityItemDagOnlyOwner.addChild(itemId, childItemStore, childNonce);
    }

}
