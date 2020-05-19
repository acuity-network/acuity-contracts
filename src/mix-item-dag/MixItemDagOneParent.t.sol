pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "../mix-item-store/MixItemStoreRegistry.sol";
import "../mix-item-store/MixItemStoreIpfsSha256.sol";

import "./MixItemDagOneParent.sol";


contract MixItemDagOneParentTest is DSTest {

    MixItemStoreRegistry mixItemStoreRegistry;
    MixItemStoreIpfsSha256 mixItemStore;
    MixItemDagOneParent mixItemDagOneParent;

    function setUp() public {
        mixItemStoreRegistry = new MixItemStoreRegistry();
        mixItemStore = new MixItemStoreIpfsSha256(mixItemStoreRegistry);
        mixItemDagOneParent = new MixItemDagOneParent(mixItemStoreRegistry);
    }

    function testControlAddChildAlreadyHasParent() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        bytes32 itemId1 = mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemDagOneParent.addChild(itemId0, mixItemStore, bytes2(0x0002));
        mixItemDagOneParent.addChild(itemId1, mixItemStore, bytes2(0x0003));
    }

    function testFailAddChildAlreadyHasParent() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        bytes32 itemId1 = mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemDagOneParent.addChild(itemId0, mixItemStore, bytes2(0x0002));
        mixItemDagOneParent.addChild(itemId1, mixItemStore, bytes2(0x0002));
    }

    function testControlAddChildParentNotExist() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemDagOneParent.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testFailAddChildParentNotExist() public {
        bytes32 itemId0 = hex"";
        mixItemDagOneParent.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testControlAddChildChildExists() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemDagOneParent.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testFailAddChildChildExists() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemDagOneParent.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testAddChild() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");

        assertEq(mixItemDagOneParent.getChildCount(itemId0), 0);
        assertEq(mixItemDagOneParent.getAllChildIds(itemId0).length, 0);
        assert(!mixItemDagOneParent.getHasParent(itemId0));

        mixItemDagOneParent.addChild(itemId0, mixItemStore, bytes2(0x0001));
        bytes32 itemId1 = mixItemStore.create(bytes2(0x0001), hex"1234");

        assertEq(mixItemDagOneParent.getChildCount(itemId0), 1);
        bytes32[] memory childIds = mixItemDagOneParent.getAllChildIds(itemId0);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId1);
        assert(!mixItemDagOneParent.getHasParent(itemId0));

        assertEq(mixItemDagOneParent.getChildCount(itemId1), 0);
        assertEq(mixItemDagOneParent.getAllChildIds(itemId1).length, 0);
        assert(mixItemDagOneParent.getHasParent(itemId1));
        assertEq(mixItemDagOneParent.getParentId(itemId1), itemId0);

        mixItemDagOneParent.addChild(itemId0, mixItemStore, bytes2(0x0002));
        bytes32 itemId2 = mixItemStore.create(bytes2(0x0002), hex"1234");

        assertEq(mixItemDagOneParent.getChildCount(itemId0), 2);
        childIds = mixItemDagOneParent.getAllChildIds(itemId0);
        assertEq(childIds.length, 2);
        assertEq(childIds[0], itemId1);
        assertEq(childIds[1], itemId2);
        assert(!mixItemDagOneParent.getHasParent(itemId0));

        assertEq(mixItemDagOneParent.getChildCount(itemId1), 0);
        assertEq(mixItemDagOneParent.getAllChildIds(itemId1).length, 0);
        assert(mixItemDagOneParent.getHasParent(itemId1));
        assertEq(mixItemDagOneParent.getParentId(itemId1), itemId0);

        assertEq(mixItemDagOneParent.getChildCount(itemId2), 0);
        assertEq(mixItemDagOneParent.getAllChildIds(itemId2).length, 0);
        assert(mixItemDagOneParent.getHasParent(itemId2));
        assertEq(mixItemDagOneParent.getParentId(itemId2), itemId0);
    }

}
