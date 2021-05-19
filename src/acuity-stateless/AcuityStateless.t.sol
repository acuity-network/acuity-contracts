// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreRegistry.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";
import "../acuity-item-dag/AcuityItemDagOnlyOwner.sol";

import "./AcuityStateless.sol";

contract AcuityStatelessTest is DSTest {
    AcuityStateless stateless;
    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStore;
    AcuityItemDagOnlyOwner acuityItemDagOnlyOwner;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStore = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        acuityItemDagOnlyOwner = new AcuityItemDagOnlyOwner(acuityItemStoreRegistry);
        stateless = new AcuityStateless(acuityItemStore, acuityItemDagOnlyOwner);
    }

    function testGetOrderedItemIdsFromFeeds() public {
        bytes32[] memory feedIds = new bytes32[](2);
        feedIds[0] = acuityItemStore.create(bytes2(0x0000), hex"1234");
        feedIds[1] = acuityItemStore.create(bytes2(0x0001), hex"1234");

        acuityItemDagOnlyOwner.addChild(feedIds[0], acuityItemStore, bytes2(0x0210));
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0210), hex"1234");
        acuityItemDagOnlyOwner.addChild(feedIds[0], acuityItemStore, bytes2(0x0220));
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0220), hex"1234");
        acuityItemDagOnlyOwner.addChild(feedIds[1], acuityItemStore, bytes2(0x0230));
        bytes32 itemId2 = acuityItemStore.create(bytes2(0x0230), hex"1234");
        acuityItemDagOnlyOwner.addChild(feedIds[1], acuityItemStore, bytes2(0x0240));
        bytes32 itemId3 = acuityItemStore.create(bytes2(0x0240), hex"1234");

        bytes32[] memory results = stateless.getOrderedItemIdsFromFeeds(feedIds, 0, 20);

        assertEq(results.length, 4);
        assertEq(results[0], itemId3);
        assertEq(results[1], itemId2);
        assertEq(results[2], itemId1);
        assertEq(results[3], itemId0);
    }
}
