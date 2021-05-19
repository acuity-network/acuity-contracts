pragma solidity ^0.6.7;

import "./AcuityAccountItems.sol";


contract AcuityAccountItemsProxy {

    AcuityAccountItems mixAccountItems;

    constructor (AcuityAccountItems _mixAccountItems) public {
        mixAccountItems = _mixAccountItems;
    }

    function addItem(bytes32 itemId) external {
        mixAccountItems.addItem(itemId);
    }

    function removeItem(bytes32 itemId) external {
        mixAccountItems.removeItem(itemId);
    }

    function getItemExists(bytes32 itemId) external view returns (bool) {
        return mixAccountItems.getItemExists(itemId);
    }

    function getItemCount() external view returns (uint) {
        return mixAccountItems.getItemCount();
    }

    function getAllItems() external view returns (bytes32[] memory) {
        return mixAccountItems.getAllItems();
    }

    function getItemExistsByAccount(address account, bytes32 itemId) external view returns (bool) {
        return mixAccountItems.getItemExistsByAccount(account, itemId);
    }

    function getItemCountByAccount(address account) external view returns (uint) {
        return mixAccountItems.getItemCountByAccount(account);
    }

    function getAllItemsByAccount(address account) external view returns (bytes32[] memory) {
        return mixAccountItems.getAllItemsByAccount(account);
    }

}
