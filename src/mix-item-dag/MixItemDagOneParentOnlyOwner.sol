pragma solidity ^0.6.7;

import "./MixItemDagOneParent.sol";


/**
 * @title MixItemDagOneParentOnlyOwner
 * @author Jonathan Brown <jbrown@mix-blockchain.org>
 * @dev Maintains a directed acyclic graph of items where each item can only have one parent and child items have the same owner as the parent.
 */
contract MixItemDagOneParentOnlyOwner is MixItemDagOneParent {

    /**
     * @param _itemStoreRegistry Address of the MixItemStoreRegistry contract.
     */
    constructor(MixItemStoreRegistry _itemStoreRegistry) MixItemDagOneParent(_itemStoreRegistry) public {}

    /**
     * @dev Add a child to an item. The child must not exist yet.
     * @param itemId itemId of the parent. Must have same owner.
     * @param childItemStore The ItemStore contract that will contain the child.
     * @param childNonce The nonce that will be used to create the child.
     */
    function addChild(bytes32 itemId, MixItemStoreInterface childItemStore, bytes32 childNonce) override external {
        // Get parent ItemStore.
        MixItemStoreInterface itemStore = itemStoreRegistry.getItemStore(itemId);
        // Ensure the parent exists.
        require (itemStore.getInUse(itemId), "Parent does not exist.");
        // Ensure the child has the same owner as the parent.
        require (itemStore.getOwner(itemId) == msg.sender, "Child has different owner than parent.");
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

}
