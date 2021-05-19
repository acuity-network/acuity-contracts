// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;

import "../acuity-item-store/AcuityItemStoreRegistry.sol";


/**
 * @title AcuityAccountItems
 * @author Jonathan Brown <jbrown@acuity.social>
 * @dev Enables users to attach a list of items to their account.
 */
contract AcuityAccountItems {

    /**
     * @dev Mapping of account to array of itemIds.
     */
    mapping (address => bytes32[]) accountItemIds;

    /**
     * @dev Mapping of account to mapping of itemId to index + 1 in accountItemIds.
     */
    mapping (address => mapping(bytes32 => uint)) accountItemIdIndex;

    /**
     * @dev AcuityItemStoreRegistry contract.
     */
    AcuityItemStoreRegistry public itemStoreRegistry;

    /**
     * @dev An account has added an item.
     * @param account Account that has added an item.
     * @param itemId itemId of item that has been added.
     */
    event AddItem(address indexed account, bytes32 indexed itemId);

    /**
     * @dev An account has removed an item.
     * @param account Account that has removed an item.
     * @param itemId itemId of item that has been removed.
     */
    event RemoveItem(address indexed account, bytes32 indexed itemId);

    /**
     * @dev Revert if the item is not in sender's list.
     * @param itemId itemId that must be in the list.
     */
    modifier isAdded(bytes32 itemId) {
        require (accountItemIdIndex[msg.sender][itemId] > 0, "Item has not been added.");
        _;
    }

    /**
     * @dev Revert if the item is in sender's list.
     * @param itemId itemId that must not be in the list.
     */
    modifier isNotAdded(bytes32 itemId) {
        require (accountItemIdIndex[msg.sender][itemId] == 0, "Item has already been added.");
        _;
    }

    /**
     * @dev Revert if the item is not owned by sender.
     * @param itemId itemId that must be owned.
     */
    modifier isOwner(bytes32 itemId) {
        require (itemStoreRegistry.getItemStore(itemId).getOwner(itemId) == msg.sender, "Item is not owned by sender.");
        _;
    }

    /**
     * @param _itemStoreRegistry Address of the AcuityItemStoreRegistry contract.
     */
    constructor(AcuityItemStoreRegistry _itemStoreRegistry) {
        // Store the address of the AcuityItemStoreRegistry contract.
        itemStoreRegistry = _itemStoreRegistry;
    }

    /**
     * @dev Add an item to the user.
     * @param itemId itemId of item to be added.
     */
    function addItem(bytes32 itemId) external isNotAdded(itemId) isOwner(itemId) {
        // Get the list of itemIds for sender.
        bytes32[] storage itemIds = accountItemIds[msg.sender];
        // Add the itemId to the list.
        itemIds.push(itemId);
        // Record the index + 1.
        accountItemIdIndex[msg.sender][itemId] = itemIds.length;
        // Log the adding of the item.
        emit AddItem(msg.sender, itemId);
    }

    /**
     * @dev Remove an item from the user.
     * @param itemId itemId of item to be removed.
     */
    function removeItem(bytes32 itemId) external isAdded(itemId) isOwner(itemId) {
        // Get the list of itemIds for sender.
        bytes32[] storage itemIds = accountItemIds[msg.sender];
        // Get the mapping of itemId indexes for sender.
        mapping(bytes32 => uint) storage itemIdIndex = accountItemIdIndex[msg.sender];
        // Get the index + 1 of the itemId to be removed and delete it from state.
        uint i = itemIdIndex[itemId];
        delete itemIdIndex[itemId];
        // Check if this is not the last itemId.
        if (i != itemIds.length) {
          // Overwrite the itemId with the last itemId.
          bytes32 itemIdMoving = itemIds[itemIds.length - 1];
          itemIds[i - 1] = itemIdMoving;
          itemIdIndex[itemIdMoving] = i;
        }
        // Remove the last itemId.
        itemIds.pop();
        // Log the removing of the item.
        emit RemoveItem(msg.sender, itemId);
    }

    /**
     * @dev Check if a specific item is in sender's list.
     * @param itemId itemId of item to check for.
     * @return True if item exists in sender's list.
     */
    function getItemExists(bytes32 itemId) external view returns (bool) {
        return accountItemIdIndex[msg.sender][itemId] > 0;
    }

    /**
     * @dev Get number of items in sender's list.
     * @return Number of items in sender's list.
     */
    function getItemCount() external view returns (uint) {
        return accountItemIds[msg.sender].length;
    }

    /**
     * @dev Get all items in sender's list.
     * @return All items in sender's list.
     */
    function getAllItems() external view returns (bytes32[] memory) {
        return accountItemIds[msg.sender];
    }

    /**
     * @dev Check if a specific item is in account's list.
     * @param account Account to check for item.
     * @param itemId itemId of item to check for.
     * @return True if item exists in sender's list.
     */
    function getItemExistsByAccount(address account, bytes32 itemId) external view returns (bool) {
        return accountItemIdIndex[account][itemId] > 0;
    }

    /**
     * @dev Get number of items in account's list.
     * @param account Account to get item count of.
     * @return Number of items in account's list.
     */
    function getItemCountByAccount(address account) external view returns (uint) {
        return accountItemIds[account].length;
    }

    /**
     * @dev Get all items in account's list.
     * @param account Account to get items of.
     * @return All items in account's list.
     */
    function getAllItemsByAccount(address account) external view returns (bytes32[] memory) {
        return accountItemIds[account];
    }

}
