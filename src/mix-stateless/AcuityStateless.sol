pragma solidity ^0.6.7;

import "../mix-item-store/AcuityItemStoreRegistry.sol";
import "../mix-item-dag/AcuityItemDagOnlyOwner.sol";


/**
 * @title AcuityStateless
 * @author Jonathan Brown <jbrown@acuity.social>
 * @dev Contract that has no state.
 */
contract AcuityStateless {

    /**
     * @dev itemStore contract.
     */
    AcuityItemStoreInterface immutable public itemStore;

    /**
     * @dev itemDagFeedItems contract.
     */
    AcuityItemDagOnlyOwner immutable public itemDagFeedItems;

    /**
     * @param _itemStore Address of the AcuityItemStoreInterface contract.
     * @param _itemDagFeedItems Address of the AcuityItemDagOnlyOwner contract.
     */
    constructor(AcuityItemStoreInterface _itemStore, AcuityItemDagOnlyOwner _itemDagFeedItems) public {
        // Store the address of the AcuityItemStore contract.
        itemStore = _itemStore;
        // Store the address of the AcuityItemDagOnlyOwner contract.
        itemDagFeedItems = _itemDagFeedItems;
    }

    struct FeedLatestItem {
        bool active;
        bytes32 feedId;
        uint offset;
        bytes32 itemId;
        uint timestamp;
    }

    /**
     * @dev Get itemIds from feeds in timestamp order.
     * @param feedIds itemIds of feeds to process.
     * @param offset Index to start returning itemIds.
     * @param limit Maximum number of itemIds to return.
     * @return itemIds Array if itemIds.
     */
    function getOrderedItemIdsFromFeeds(bytes32[] calldata feedIds, uint offset, uint limit) external view returns (bytes32[] memory itemIds) {
        // Allocate array of FeedLatestItem.
        FeedLatestItem[] memory feedLatestItem = new FeedLatestItem[](feedIds.length);
        // Populate array of FeedLatestItem.
        for (uint i = 0; i < feedIds.length; i++) {
            uint childCount = itemDagFeedItems.getChildCount(feedIds[i]);
            // Does this feed have any items?
            if (childCount > 0) {
                bytes32 itemId = itemDagFeedItems.getChildId(feedIds[i], childCount - 1);
                // Check that the item is enforcing revisioning and has not been retracted.
                if (!itemStore.getEnforceRevisions(itemId) ||
                    itemStore.getRevisionCount(itemId) == 0)
                {
                    continue;
                }
                feedLatestItem[i] = FeedLatestItem({
                    active: true,
                    feedId: feedIds[i],
                    offset: childCount - 1,
                    itemId: itemId,
                    timestamp: itemStore.getRevisionTimestamp(itemId, 0)
                });
            }
        }
        // Find itemIds in timestamp order.
        bytes32[] memory tempItemIds = new bytes32[](limit);
        uint itemCount = 0;
        bool found;
        do {
            found = false;
            uint mostRecent;
            // Find the most recent item.
            for (uint i = 0; i < feedIds.length; i++) {
                if (!feedLatestItem[i].active) {
                    continue;
                }
                if (found) {
                    // Timestamp == 0 for unconfirmed txs.
                    if (feedLatestItem[i].timestamp == 0 ||
                        feedLatestItem[i].timestamp > feedLatestItem[mostRecent].timestamp) {
                        mostRecent = i;
                    }
                }
                else {
                    mostRecent = i;
                    found = true;
                }
            }
            if (found) {
                // Have we found enough itemIds to start storing them yet?
                if (offset == 0) {
                    // Store the found itemId.
                    tempItemIds[itemCount++] = feedLatestItem[mostRecent].itemId;
                }
                else {
                    offset--;
                }
                // Are there any more items its feed?
                if (feedLatestItem[mostRecent].offset == 0) {
                    feedLatestItem[mostRecent].active = false;
                }
                else {
                    // Find the next valid item in its feed.
                    while (true) {
                        uint feedOffset = --feedLatestItem[mostRecent].offset;
                        bytes32 itemId = itemDagFeedItems.getChildId(feedLatestItem[mostRecent].feedId, feedOffset);
                        // Check that the item is enforcing revisioning and has not been retracted.
                        if (!itemStore.getEnforceRevisions(itemId) ||
                            itemStore.getRevisionCount(itemId) == 0)
                        {
                            // Is this the final item in the feed?
                            if (feedLatestItem[mostRecent].offset == 0) {
                                feedLatestItem[mostRecent].active = false;
                                break;
                            }
                            continue;
                        }
                        feedLatestItem[mostRecent].itemId = itemId;
                        feedLatestItem[mostRecent].timestamp = itemStore.getRevisionTimestamp(itemId, 0);
                        break;
                    }
                }
            }
        }
        while (itemCount < limit && found);
        // Allocate return array and populate.
        itemIds = new bytes32[](itemCount);
        for (uint i = 0; i < itemCount; i++) {
            itemIds[i] = tempItemIds[i];
        }
    }

}
