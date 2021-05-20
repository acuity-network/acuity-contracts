// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "../acuity-item-store/AcuityItemStoreInterface.sol";
import "../acuity-item-store/AcuityItemStoreRegistry.sol";


/**
 * @title AcuityItemDag
 * @author Jonathan Brown <jbrown@acuity.social>
 * @dev Maintains a directed acyclic graph of items.
 */
contract AcuityItemDag {

    /**
     * @dev Single slot structure of item state.
     */
    struct ItemState {
        uint128 childCount;      // Number of children.
        uint128 parentCount;     // Number of parents.
    }

    /**
     * @dev Mapping of itemId to item state.
     */
    mapping (bytes32 => ItemState) itemState;

    /**
     * @dev Mapping of itemId to mapping of index to child itemId.
     */
    mapping (bytes32 => mapping(uint => bytes32)) itemChildIds;

    /**
     * @dev Mapping of itemId to mapping of index to parent itemId.
     */
    mapping (bytes32 => mapping(uint => bytes32)) itemParentIds;

    /**
     * @dev AcuityItemStoreRegistry contract.
     */
    AcuityItemStoreRegistry public itemStoreRegistry;

    /**
     * @dev A child item has been attached to an item.
     * @param itemId itemId of the parent.
     * @param owner owner of the parent.
     * @param childId itemId of the child.
     * @param i Index of the new child.
     */
    event AddChild(bytes32 indexed itemId, address indexed owner, bytes32 childId, uint i);

    /**
     * @dev Revert if a specific item child does not exist.
     * @param itemId itemId of the item.
     * @param i Index of the child.
     */
    modifier childExists(bytes32 itemId, uint i) {
        require (i < itemState[itemId].childCount, "Child does not exist.");
        _;
    }

    /**
     * @dev Revert if a specific item parent does not exist.
     * @param itemId itemId of the item.
     * @param i Index of the parent.
     */
    modifier parentExists(bytes32 itemId, uint i) {
        require (i < itemState[itemId].parentCount, "Parent does not exist.");
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
     * @dev Add a child to an item. The child must not exist yet.
     * @param itemId itemId of the parent.
     * @param childItemStore The ItemStore contract that will contain the child.
     * @param childNonce The nonce that will be used to create the child.
     */
    function addChild(bytes32 itemId, AcuityItemStoreInterface childItemStore, bytes32 childNonce) virtual external {
        // Ensure the parent exists.
        require (itemStoreRegistry.getItemStore(itemId).getInUse(itemId), "Parent does not exist.");
        // Get the child itemId. Ensure it does not exist.
        bytes32 childId = childItemStore.getNewItemId(msg.sender, childNonce);

        // Get parent state.
        ItemState storage state = itemState[itemId];
        // Get the index of the new child.
        uint i = state.childCount;
        // Store the childId.
        itemChildIds[itemId][i] = childId;
        // Increment the child count.
        state.childCount = uint128(i + 1);
        // Log the new child.
        emit AddChild(itemId, msg.sender, childId, i);

        // Get child state.
        state = itemState[childId];
        // Get the index of the new parent.
        i = state.parentCount;
        // Store the parentId.
        itemParentIds[childId][i] = itemId;
        // Increment the parent count.
        state.parentCount = uint128(i + 1);
    }

    /**
     * @dev Get the number of children an item has.
     * @param itemId itemId of the item.
     * @return How many children the item has.
     */
    function getChildCount(bytes32 itemId) external view returns (uint) {
        return itemState[itemId].childCount;
    }

    /**
     * @dev Get a specific child.
     * @param itemId itemId of the item.
     * @param i Index of the child.
     * @return itemId of the child.
     */
    function getChildId(bytes32 itemId, uint i) external view childExists(itemId, i) returns (bytes32) {
        return itemChildIds[itemId][i];
    }

    /**
     * @dev Get all of an item's children.
     * @param itemId itemId of the item.
     * @return childIds itemIds of the item's children.
     */
    function getAllChildIds(bytes32 itemId) public view returns (bytes32[] memory childIds) {
        uint count = itemState[itemId].childCount;
        childIds = new bytes32[](count);
        for (uint i = 0; i < count; i++) {
            childIds[i] = itemChildIds[itemId][i];
        }
    }

    /**
     * @dev Get the number of parents an item has.
     * @param itemId itemId of the item.
     * @return How many parents the item has.
     */
    function getParentCount(bytes32 itemId) external view returns (uint) {
        return itemState[itemId].parentCount;
    }

    /**
     * @dev Get a specific parent.
     * @param itemId itemId of the item.
     * @param i Index of the parent.
     * @return itemId of the parent.
     */
    function getParentId(bytes32 itemId, uint i) external view parentExists(itemId, i) returns (bytes32) {
        return itemParentIds[itemId][i];
    }

    /**
     * @dev Get all of an item's parents.
     * @param itemId itemId of the item.
     * @return parentIds itemIds of the item's parents.
     */
    function getAllParentIds(bytes32 itemId) public view returns (bytes32[] memory parentIds) {
        uint count = itemState[itemId].parentCount;
        parentIds = new bytes32[](count);
        for (uint i = 0; i < count; i++) {
            parentIds[i] = itemParentIds[itemId][i];
        }
    }

    /**
     * @dev Get all of an item's children and parents.
     * @param itemId itemId of the item.
     * @return childIds itemIds of the children.
     * @return parentIds itemIds of the parents.
     */
    function getItem(bytes32 itemId) external view returns (bytes32[] memory childIds, bytes32[] memory parentIds) {
        childIds = getAllChildIds(itemId);
        parentIds = getAllParentIds(itemId);
    }

}
