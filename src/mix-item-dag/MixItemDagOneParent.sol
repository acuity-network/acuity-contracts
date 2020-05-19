pragma solidity ^0.6.6;

import "mix-item-store/MixItemStoreInterface.sol";
import "mix-item-store/MixItemStoreRegistry.sol";


/**
 * @title MixItemDagOneParent
 * @author Jonathan Brown <jbrown@mix-blockchain.org>
 * @dev Maintains a directed acyclic graph of items where each item can only have one parent.
 */
contract MixItemDagOneParent {

    /**
     * @dev Mapping of itemId to item child count.
     */
    mapping (bytes32 => uint) itemChildCount;

    /**
     * @dev Mapping of itemId to mapping of index to child itemId.
     */
    mapping (bytes32 => mapping(uint => bytes32)) itemChildIds;

    /**
     * @dev Mapping of itemId to parent itemId.
     */
    mapping (bytes32 => bytes32) itemParentId;

    /**
     * @dev MixItemStoreRegistry contract.
     */
    MixItemStoreRegistry public itemStoreRegistry;

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
        require (i < itemChildCount[itemId], "Child does not exist.");
        _;
    }

    /**
     * @dev Revert if an item does not have a parent.
     * @param itemId itemId of the item.
     */
    modifier hasParent(bytes32 itemId) {
        require (itemParentId[itemId] != 0, "Item does not have a parent.");
        _;
    }

    /**
     * @param _itemStoreRegistry Address of the MixItemStoreRegistry contract.
     */
    constructor(MixItemStoreRegistry _itemStoreRegistry) public {
        // Store the address of the MixItemStoreRegistry contract.
        itemStoreRegistry = _itemStoreRegistry;
    }

    /**
     * @dev Add a child to an item. The child must not exist yet.
     * @param itemId itemId of the parent.
     * @param childItemStore The ItemStore contract that will contain the child.
     * @param childNonce The nonce that will be used to create the child.
     */
    function addChild(bytes32 itemId, MixItemStoreInterface childItemStore, bytes32 childNonce) virtual external {
        // Ensure the parent exists.
        require (itemStoreRegistry.getItemStore(itemId).getInUse(itemId), "Parent does not exist.");
        // Get the child itemId. Ensure it does not exist.
        bytes32 childId = childItemStore.getNewItemId(msg.sender, childNonce);
        // Ensure the child doesn't have a parent already.
        require (itemParentId[childId] == 0, "Child already has a parent.");

        // Get the index of the new child.
        uint i = itemChildCount[itemId];
        // Store the childId.
        itemChildIds[itemId][i] = childId;
        // Increment the child count.
        itemChildCount[itemId] = i + 1;
        // Log the new child.
        emit AddChild(itemId, msg.sender, childId, i);

        // Store the parentId.
        itemParentId[childId] = itemId;
    }

    /**
     * @dev Get the number of children an item has.
     * @param itemId itemId of the item.
     * @return How many children the item has.
     */
    function getChildCount(bytes32 itemId) external view returns (uint) {
        return itemChildCount[itemId];
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
        uint count = itemChildCount[itemId];
        childIds = new bytes32[](count);
        for (uint i = 0; i < count; i++) {
            childIds[i] = itemChildIds[itemId][i];
        }
    }

    /**
     * @dev Determine if an item has a parent.
     * @param itemId itemId of the item.
     * @return True if the item has a parent.
     */
    function getHasParent(bytes32 itemId) public view returns (bool) {
        return itemParentId[itemId] != 0;
    }

    /**
     * @dev Get a parentId of an item.
     * @param itemId itemId of the item.
     * @return itemId of the parent.
     */
    function getParentId(bytes32 itemId) public view hasParent(itemId) returns (bytes32) {
        return itemParentId[itemId];
    }

    /**
     * @dev Get all of an item's children and parents.
     * @param itemId itemId of the item.
     * @return childIds itemIds of the children.
     * @return parentId itemId of the the parents.
     */
    function getItem(bytes32 itemId) external view returns (bytes32[] memory childIds, bytes32 parentId) {
        childIds = getAllChildIds(itemId);
        parentId = getParentId(itemId);
    }

}
