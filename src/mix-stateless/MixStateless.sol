pragma solidity ^0.6.7;

import "../mix-item-store/MixItemStoreRegistry.sol";
import "../mix-item-dag/MixItemDagOnlyOwner.sol";


struct FeedItemEntry {
  bytes32 feedId;
  uint offset;
  bytes32 itemId;
  uint timestamp;
}


contract MixStateless {

    /**
     * @dev MixItemStore contract.
     */
    MixItemStoreInterface immutable public itemStore;

    MixItemDagOnlyOwner immutable public itemDagFeedItems;

    /**
     * @param _itemStore Address of the MixItemStoreInterface contract.
     * @param _itemDagFeedItems Address of the MixItemDagOnlyOwner contract.
     */
    constructor(MixItemStoreInterface _itemStore, MixItemDagOnlyOwner _itemDagFeedItems) public {
        // Store the address of the MixItemStore contract.
        itemStore = _itemStore;
        // Store the address of the MixItemDagOnlyOwner contract.
        itemDagFeedItems = _itemDagFeedItems;
    }

    function getFeedsItemIds(bytes32[] calldata feedIds) external {

        FeedItemEntry[] memory feedItemEntries = new FeedItemEntry[](feedIds.length);


    }

}
