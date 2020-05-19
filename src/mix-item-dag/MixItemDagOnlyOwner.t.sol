pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "../mix-item-store/MixItemStoreRegistry.sol";
import "../mix-item-store/MixItemStoreIpfsSha256.sol";

import "./MixItemDagOnlyOwner.sol";
import "./MixItemDagOnlyOwnerProxy.sol";


contract MixItemDagOnlyOwnerTest is DSTest {

    MixItemStoreRegistry mixItemStoreRegistry;
    MixItemStoreIpfsSha256 mixItemStore;
    MixItemDagOnlyOwner mixItemDagOnlyOwner;
    MixItemDagOnlyOwnerProxy mixItemDagOnlyOwnerProxy;

    function setUp() public {
        mixItemStoreRegistry = new MixItemStoreRegistry();
        mixItemStore = new MixItemStoreIpfsSha256(mixItemStoreRegistry);
        mixItemDagOnlyOwner = new MixItemDagOnlyOwner(mixItemStoreRegistry);
        mixItemDagOnlyOwnerProxy = new MixItemDagOnlyOwnerProxy(mixItemDagOnlyOwner);
    }

    function testControlAddChildItemNotInUse() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemDagOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testFailAddChildItemNotInUse() public {
        bytes32 itemId0 = hex"";
        mixItemDagOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testControlAddChildItemDifferentOwner() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemDagOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testFailAddChildItemDifferentOwner() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemDagOnlyOwnerProxy.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testControlAddChildChildExists() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemDagOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testFailAddChildChildExists() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemDagOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testAddChild() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");

        assertEq(mixItemDagOnlyOwner.getChildCount(itemId0), 0);
        assertEq(mixItemDagOnlyOwner.getAllChildIds(itemId0).length, 0);
        assertEq(mixItemDagOnlyOwner.getParentCount(itemId0), 0);
        assertEq(mixItemDagOnlyOwner.getAllParentIds(itemId0).length, 0);

        mixItemDagOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0001));
        bytes32 itemId1 = mixItemStore.create(bytes2(0x0001), hex"1234");

        assertEq(mixItemDagOnlyOwner.getChildCount(itemId0), 1);
        bytes32[] memory childIds = mixItemDagOnlyOwner.getAllChildIds(itemId0);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId1);
        assertEq(mixItemDagOnlyOwner.getParentCount(itemId0), 0);
        assertEq(mixItemDagOnlyOwner.getAllParentIds(itemId0).length, 0);

        assertEq(mixItemDagOnlyOwner.getChildCount(itemId1), 0);
        assertEq(mixItemDagOnlyOwner.getAllChildIds(itemId1).length, 0);
        assertEq(mixItemDagOnlyOwner.getParentCount(itemId1), 1);
        bytes32[] memory parentIds = mixItemDagOnlyOwner.getAllParentIds(itemId1);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        mixItemDagOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0002));
        bytes32 itemId2 = mixItemStore.create(bytes2(0x0002), hex"1234");

        assertEq(mixItemDagOnlyOwner.getChildCount(itemId0), 2);
        childIds = mixItemDagOnlyOwner.getAllChildIds(itemId0);
        assertEq(childIds.length, 2);
        assertEq(childIds[0], itemId1);
        assertEq(childIds[1], itemId2);
        assertEq(mixItemDagOnlyOwner.getParentCount(itemId0), 0);
        assertEq(mixItemDagOnlyOwner.getAllParentIds(itemId0).length, 0);

        assertEq(mixItemDagOnlyOwner.getChildCount(itemId1), 0);
        assertEq(mixItemDagOnlyOwner.getAllChildIds(itemId1).length, 0);
        assertEq(mixItemDagOnlyOwner.getParentCount(itemId1), 1);
        parentIds = mixItemDagOnlyOwner.getAllParentIds(itemId1);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        assertEq(mixItemDagOnlyOwner.getChildCount(itemId2), 0);
        assertEq(mixItemDagOnlyOwner.getAllChildIds(itemId2).length, 0);
        assertEq(mixItemDagOnlyOwner.getParentCount(itemId2), 1);
        parentIds = mixItemDagOnlyOwner.getAllParentIds(itemId2);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        mixItemDagOnlyOwner.addChild(itemId1, mixItemStore, bytes2(0x0003));
        mixItemDagOnlyOwner.addChild(itemId2, mixItemStore, bytes2(0x0003));
        bytes32 itemId3 = mixItemStore.create(bytes2(0x0003), hex"1234");

        assertEq(mixItemDagOnlyOwner.getChildCount(itemId0), 2);
        childIds = mixItemDagOnlyOwner.getAllChildIds(itemId0);
        assertEq(childIds.length, 2);
        assertEq(childIds[0], itemId1);
        assertEq(childIds[1], itemId2);
        assertEq(mixItemDagOnlyOwner.getParentCount(itemId0), 0);
        assertEq(mixItemDagOnlyOwner.getAllParentIds(itemId0).length, 0);

        assertEq(mixItemDagOnlyOwner.getChildCount(itemId1), 1);
        childIds = mixItemDagOnlyOwner.getAllChildIds(itemId1);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId3);
        assertEq(mixItemDagOnlyOwner.getParentCount(itemId1), 1);
        parentIds = mixItemDagOnlyOwner.getAllParentIds(itemId1);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        assertEq(mixItemDagOnlyOwner.getChildCount(itemId2), 1);
        childIds = mixItemDagOnlyOwner.getAllChildIds(itemId2);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId3);
        assertEq(mixItemDagOnlyOwner.getParentCount(itemId2), 1);
        parentIds = mixItemDagOnlyOwner.getAllParentIds(itemId2);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        assertEq(mixItemDagOnlyOwner.getChildCount(itemId3), 0);
        assertEq(mixItemDagOnlyOwner.getAllChildIds(itemId3).length, 0);
        assertEq(mixItemDagOnlyOwner.getParentCount(itemId3), 2);
        parentIds = mixItemDagOnlyOwner.getAllParentIds(itemId3);
        assertEq(parentIds.length, 2);
        assertEq(parentIds[0], itemId1);
        assertEq(parentIds[1], itemId2);
    }

}
