pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreRegistry.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";

import "./AcuityItemDagOneParent.sol";


contract AcuityItemDagOneParentTest is DSTest {

    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStore;
    AcuityItemDagOneParent acuityItemDagOneParent;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStore = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        acuityItemDagOneParent = new AcuityItemDagOneParent(acuityItemStoreRegistry);
    }

    function testControlAddChildAlreadyHasParent() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemDagOneParent.addChild(itemId0, acuityItemStore, bytes2(0x0002));
        acuityItemDagOneParent.addChild(itemId1, acuityItemStore, bytes2(0x0003));
    }

    function testFailAddChildAlreadyHasParent() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemDagOneParent.addChild(itemId0, acuityItemStore, bytes2(0x0002));
        acuityItemDagOneParent.addChild(itemId1, acuityItemStore, bytes2(0x0002));
    }

    function testControlAddChildParentNotExist() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemDagOneParent.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testFailAddChildParentNotExist() public {
        bytes32 itemId0 = hex"";
        acuityItemDagOneParent.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testControlAddChildChildExists() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemDagOneParent.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testFailAddChildChildExists() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemDagOneParent.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testAddChild() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");

        assertEq(acuityItemDagOneParent.getChildCount(itemId0), 0);
        assertEq(acuityItemDagOneParent.getAllChildIds(itemId0).length, 0);
        assert(!acuityItemDagOneParent.getHasParent(itemId0));

        acuityItemDagOneParent.addChild(itemId0, acuityItemStore, bytes2(0x0001));
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0001), hex"1234");

        assertEq(acuityItemDagOneParent.getChildCount(itemId0), 1);
        bytes32[] memory childIds = acuityItemDagOneParent.getAllChildIds(itemId0);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId1);
        assert(!acuityItemDagOneParent.getHasParent(itemId0));

        assertEq(acuityItemDagOneParent.getChildCount(itemId1), 0);
        assertEq(acuityItemDagOneParent.getAllChildIds(itemId1).length, 0);
        assert(acuityItemDagOneParent.getHasParent(itemId1));
        assertEq(acuityItemDagOneParent.getParentId(itemId1), itemId0);

        acuityItemDagOneParent.addChild(itemId0, acuityItemStore, bytes2(0x0002));
        bytes32 itemId2 = acuityItemStore.create(bytes2(0x0002), hex"1234");

        assertEq(acuityItemDagOneParent.getChildCount(itemId0), 2);
        childIds = acuityItemDagOneParent.getAllChildIds(itemId0);
        assertEq(childIds.length, 2);
        assertEq(childIds[0], itemId1);
        assertEq(childIds[1], itemId2);
        assert(!acuityItemDagOneParent.getHasParent(itemId0));

        assertEq(acuityItemDagOneParent.getChildCount(itemId1), 0);
        assertEq(acuityItemDagOneParent.getAllChildIds(itemId1).length, 0);
        assert(acuityItemDagOneParent.getHasParent(itemId1));
        assertEq(acuityItemDagOneParent.getParentId(itemId1), itemId0);

        assertEq(acuityItemDagOneParent.getChildCount(itemId2), 0);
        assertEq(acuityItemDagOneParent.getAllChildIds(itemId2).length, 0);
        assert(acuityItemDagOneParent.getHasParent(itemId2));
        assertEq(acuityItemDagOneParent.getParentId(itemId2), itemId0);
    }

}
