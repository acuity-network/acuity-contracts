pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "../mix-item-store/MixItemStoreRegistry.sol";
import "../mix-item-store/MixItemStoreIpfsSha256.sol";
import "../mix-item-dag/MixItemDagOnlyOwner.sol";

import "./MixStateless.sol";

contract MixStatelessTest is DSTest {
    MixStateless stateless;
    MixItemStoreRegistry mixItemStoreRegistry;
    MixItemStoreIpfsSha256 mixItemStore;
    MixItemDagOnlyOwner mixItemDagOnlyOwner;

    function setUp() public {
        mixItemStoreRegistry = new MixItemStoreRegistry();
        mixItemStore = new MixItemStoreIpfsSha256(mixItemStoreRegistry);
        mixItemDagOnlyOwner = new MixItemDagOnlyOwner(mixItemStoreRegistry);
        stateless = new MixStateless(mixItemStore, mixItemDagOnlyOwner);
    }

    function testGetOrderedItemIdsFromFeeds() public {
        bytes32[] memory feedIds = new bytes32[](2);
        feedIds[0] = mixItemStore.create(bytes2(0x0000), hex"1234");
        feedIds[1] = mixItemStore.create(bytes2(0x0001), hex"1234");

        mixItemDagOnlyOwner.addChild(feedIds[0], mixItemStore, bytes2(0x0210));
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0210), hex"1234");
        mixItemDagOnlyOwner.addChild(feedIds[0], mixItemStore, bytes2(0x0220));
        bytes32 itemId1 = mixItemStore.create(bytes2(0x0220), hex"1234");
        mixItemDagOnlyOwner.addChild(feedIds[1], mixItemStore, bytes2(0x0230));
        bytes32 itemId2 = mixItemStore.create(bytes2(0x0230), hex"1234");
        mixItemDagOnlyOwner.addChild(feedIds[1], mixItemStore, bytes2(0x0240));
        bytes32 itemId3 = mixItemStore.create(bytes2(0x0240), hex"1234");

        bytes32[] memory results = stateless.getOrderedItemIdsFromFeeds(feedIds, 0, 20);

        assertEq(results.length, 4);
        assertEq(results[0], itemId3);
        assertEq(results[1], itemId2);
        assertEq(results[2], itemId1);
        assertEq(results[3], itemId0);
    }
}
