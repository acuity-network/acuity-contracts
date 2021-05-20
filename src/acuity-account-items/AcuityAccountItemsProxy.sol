// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "./AcuityAccountItems.sol";


contract AcuityAccountItemsProxy {

    AcuityAccountItems acuityAccountItems;

    constructor (AcuityAccountItems _acuityAccountItems) {
        acuityAccountItems = _acuityAccountItems;
    }

    function addItem(bytes32 itemId) external {
        acuityAccountItems.addItem(itemId);
    }

    function removeItem(bytes32 itemId) external {
        acuityAccountItems.removeItem(itemId);
    }

    function getItemExists(bytes32 itemId) external view returns (bool) {
        return acuityAccountItems.getItemExists(itemId);
    }

    function getItemCount() external view returns (uint) {
        return acuityAccountItems.getItemCount();
    }

    function getAllItems() external view returns (bytes32[] memory) {
        return acuityAccountItems.getAllItems();
    }

    function getItemExistsByAccount(address account, bytes32 itemId) external view returns (bool) {
        return acuityAccountItems.getItemExistsByAccount(account, itemId);
    }

    function getItemCountByAccount(address account) external view returns (uint) {
        return acuityAccountItems.getItemCountByAccount(account);
    }

    function getAllItemsByAccount(address account) external view returns (bytes32[] memory) {
        return acuityAccountItems.getAllItemsByAccount(account);
    }

}
