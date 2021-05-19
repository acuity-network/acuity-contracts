pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreRegistry.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";

import "./AcuityItemDag.sol";


contract AcuityItemDagTest is DSTest {

    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStore;
    AcuityItemDag acuityItemDag;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStore = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        acuityItemDag = new AcuityItemDag(acuityItemStoreRegistry);
    }

    function testControlAddChildItemNotInUse() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemDag.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testFailAddChildItemNotInUse() public {
        bytes32 itemId0 = hex"";
        acuityItemDag.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testControlAddChildChildExists() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemDag.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testFailAddChildChildExists() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemDag.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testAddChild() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");

        assertEq(acuityItemDag.getChildCount(itemId0), 0);
        assertEq(acuityItemDag.getAllChildIds(itemId0).length, 0);
        assertEq(acuityItemDag.getParentCount(itemId0), 0);
        assertEq(acuityItemDag.getAllParentIds(itemId0).length, 0);

        acuityItemDag.addChild(itemId0, acuityItemStore, bytes2(0x0001));
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0001), hex"1234");

        assertEq(acuityItemDag.getChildCount(itemId0), 1);
        bytes32[] memory childIds = acuityItemDag.getAllChildIds(itemId0);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId1);
        assertEq(acuityItemDag.getParentCount(itemId0), 0);
        assertEq(acuityItemDag.getAllParentIds(itemId0).length, 0);

        assertEq(acuityItemDag.getChildCount(itemId1), 0);
        assertEq(acuityItemDag.getAllChildIds(itemId1).length, 0);
        assertEq(acuityItemDag.getParentCount(itemId1), 1);
        bytes32[] memory parentIds = acuityItemDag.getAllParentIds(itemId1);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        acuityItemDag.addChild(itemId0, acuityItemStore, bytes2(0x0002));
        bytes32 itemId2 = acuityItemStore.create(bytes2(0x0002), hex"1234");

        assertEq(acuityItemDag.getChildCount(itemId0), 2);
        childIds = acuityItemDag.getAllChildIds(itemId0);
        assertEq(childIds.length, 2);
        assertEq(childIds[0], itemId1);
        assertEq(childIds[1], itemId2);
        assertEq(acuityItemDag.getParentCount(itemId0), 0);
        assertEq(acuityItemDag.getAllParentIds(itemId0).length, 0);

        assertEq(acuityItemDag.getChildCount(itemId1), 0);
        assertEq(acuityItemDag.getAllChildIds(itemId1).length, 0);
        assertEq(acuityItemDag.getParentCount(itemId1), 1);
        parentIds = acuityItemDag.getAllParentIds(itemId1);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        assertEq(acuityItemDag.getChildCount(itemId2), 0);
        assertEq(acuityItemDag.getAllChildIds(itemId2).length, 0);
        assertEq(acuityItemDag.getParentCount(itemId2), 1);
        parentIds = acuityItemDag.getAllParentIds(itemId2);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        acuityItemDag.addChild(itemId1, acuityItemStore, bytes2(0x0003));
        acuityItemDag.addChild(itemId2, acuityItemStore, bytes2(0x0003));
        bytes32 itemId3 = acuityItemStore.create(bytes2(0x0003), hex"1234");

        assertEq(acuityItemDag.getChildCount(itemId0), 2);
        childIds = acuityItemDag.getAllChildIds(itemId0);
        assertEq(childIds.length, 2);
        assertEq(childIds[0], itemId1);
        assertEq(childIds[1], itemId2);
        assertEq(acuityItemDag.getParentCount(itemId0), 0);
        assertEq(acuityItemDag.getAllParentIds(itemId0).length, 0);

        assertEq(acuityItemDag.getChildCount(itemId1), 1);
        childIds = acuityItemDag.getAllChildIds(itemId1);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId3);
        assertEq(acuityItemDag.getParentCount(itemId1), 1);
        parentIds = acuityItemDag.getAllParentIds(itemId1);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        assertEq(acuityItemDag.getChildCount(itemId2), 1);
        childIds = acuityItemDag.getAllChildIds(itemId2);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId3);
        assertEq(acuityItemDag.getParentCount(itemId2), 1);
        parentIds = acuityItemDag.getAllParentIds(itemId2);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        assertEq(acuityItemDag.getChildCount(itemId3), 0);
        assertEq(acuityItemDag.getAllChildIds(itemId3).length, 0);
        assertEq(acuityItemDag.getParentCount(itemId3), 2);
        parentIds = acuityItemDag.getAllParentIds(itemId3);
        assertEq(parentIds.length, 2);
        assertEq(parentIds[0], itemId1);
        assertEq(parentIds[1], itemId2);
    }

}
