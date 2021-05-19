// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreRegistry.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";

import "./AcuityItemDagOnlyOwner.sol";
import "./AcuityItemDagOnlyOwnerProxy.sol";


contract AcuityItemDagOnlyOwnerTest is DSTest {

    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStore;
    AcuityItemDagOnlyOwner acuityItemDagOnlyOwner;
    AcuityItemDagOnlyOwnerProxy acuityItemDagOnlyOwnerProxy;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStore = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        acuityItemDagOnlyOwner = new AcuityItemDagOnlyOwner(acuityItemStoreRegistry);
        acuityItemDagOnlyOwnerProxy = new AcuityItemDagOnlyOwnerProxy(acuityItemDagOnlyOwner);
    }

    function testControlAddChildItemNotInUse() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemDagOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testFailAddChildItemNotInUse() public {
        bytes32 itemId0 = hex"";
        acuityItemDagOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testControlAddChildItemDifferentOwner() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemDagOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testFailAddChildItemDifferentOwner() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemDagOnlyOwnerProxy.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testControlAddChildChildExists() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemDagOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testFailAddChildChildExists() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemDagOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testAddChild() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");

        assertEq(acuityItemDagOnlyOwner.getChildCount(itemId0), 0);
        assertEq(acuityItemDagOnlyOwner.getAllChildIds(itemId0).length, 0);
        assertEq(acuityItemDagOnlyOwner.getParentCount(itemId0), 0);
        assertEq(acuityItemDagOnlyOwner.getAllParentIds(itemId0).length, 0);

        acuityItemDagOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0001));
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0001), hex"1234");

        assertEq(acuityItemDagOnlyOwner.getChildCount(itemId0), 1);
        bytes32[] memory childIds = acuityItemDagOnlyOwner.getAllChildIds(itemId0);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId1);
        assertEq(acuityItemDagOnlyOwner.getParentCount(itemId0), 0);
        assertEq(acuityItemDagOnlyOwner.getAllParentIds(itemId0).length, 0);

        assertEq(acuityItemDagOnlyOwner.getChildCount(itemId1), 0);
        assertEq(acuityItemDagOnlyOwner.getAllChildIds(itemId1).length, 0);
        assertEq(acuityItemDagOnlyOwner.getParentCount(itemId1), 1);
        bytes32[] memory parentIds = acuityItemDagOnlyOwner.getAllParentIds(itemId1);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        acuityItemDagOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0002));
        bytes32 itemId2 = acuityItemStore.create(bytes2(0x0002), hex"1234");

        assertEq(acuityItemDagOnlyOwner.getChildCount(itemId0), 2);
        childIds = acuityItemDagOnlyOwner.getAllChildIds(itemId0);
        assertEq(childIds.length, 2);
        assertEq(childIds[0], itemId1);
        assertEq(childIds[1], itemId2);
        assertEq(acuityItemDagOnlyOwner.getParentCount(itemId0), 0);
        assertEq(acuityItemDagOnlyOwner.getAllParentIds(itemId0).length, 0);

        assertEq(acuityItemDagOnlyOwner.getChildCount(itemId1), 0);
        assertEq(acuityItemDagOnlyOwner.getAllChildIds(itemId1).length, 0);
        assertEq(acuityItemDagOnlyOwner.getParentCount(itemId1), 1);
        parentIds = acuityItemDagOnlyOwner.getAllParentIds(itemId1);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        assertEq(acuityItemDagOnlyOwner.getChildCount(itemId2), 0);
        assertEq(acuityItemDagOnlyOwner.getAllChildIds(itemId2).length, 0);
        assertEq(acuityItemDagOnlyOwner.getParentCount(itemId2), 1);
        parentIds = acuityItemDagOnlyOwner.getAllParentIds(itemId2);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        acuityItemDagOnlyOwner.addChild(itemId1, acuityItemStore, bytes2(0x0003));
        acuityItemDagOnlyOwner.addChild(itemId2, acuityItemStore, bytes2(0x0003));
        bytes32 itemId3 = acuityItemStore.create(bytes2(0x0003), hex"1234");

        assertEq(acuityItemDagOnlyOwner.getChildCount(itemId0), 2);
        childIds = acuityItemDagOnlyOwner.getAllChildIds(itemId0);
        assertEq(childIds.length, 2);
        assertEq(childIds[0], itemId1);
        assertEq(childIds[1], itemId2);
        assertEq(acuityItemDagOnlyOwner.getParentCount(itemId0), 0);
        assertEq(acuityItemDagOnlyOwner.getAllParentIds(itemId0).length, 0);

        assertEq(acuityItemDagOnlyOwner.getChildCount(itemId1), 1);
        childIds = acuityItemDagOnlyOwner.getAllChildIds(itemId1);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId3);
        assertEq(acuityItemDagOnlyOwner.getParentCount(itemId1), 1);
        parentIds = acuityItemDagOnlyOwner.getAllParentIds(itemId1);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        assertEq(acuityItemDagOnlyOwner.getChildCount(itemId2), 1);
        childIds = acuityItemDagOnlyOwner.getAllChildIds(itemId2);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId3);
        assertEq(acuityItemDagOnlyOwner.getParentCount(itemId2), 1);
        parentIds = acuityItemDagOnlyOwner.getAllParentIds(itemId2);
        assertEq(parentIds.length, 1);
        assertEq(parentIds[0], itemId0);

        assertEq(acuityItemDagOnlyOwner.getChildCount(itemId3), 0);
        assertEq(acuityItemDagOnlyOwner.getAllChildIds(itemId3).length, 0);
        assertEq(acuityItemDagOnlyOwner.getParentCount(itemId3), 2);
        parentIds = acuityItemDagOnlyOwner.getAllParentIds(itemId3);
        assertEq(parentIds.length, 2);
        assertEq(parentIds[0], itemId1);
        assertEq(parentIds[1], itemId2);
    }

}
