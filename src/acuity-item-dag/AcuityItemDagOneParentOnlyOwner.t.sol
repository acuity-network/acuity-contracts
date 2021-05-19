pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreRegistry.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";

import "./AcuityItemDagOneParentOnlyOwner.sol";
import "./AcuityItemDagOneParentOnlyOwnerProxy.sol";


contract AcuityItemDagOneParentOnlyOwnerTest is DSTest {

    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStore;
    AcuityItemDagOneParentOnlyOwner acuityItemDagOneParentOnlyOwner;
    AcuityItemDagOneParentOnlyOwnerProxy acuityItemDagOneParentOnlyOwnerProxy;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStore = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        acuityItemDagOneParentOnlyOwner = new AcuityItemDagOneParentOnlyOwner(acuityItemStoreRegistry);
        acuityItemDagOneParentOnlyOwnerProxy = new AcuityItemDagOneParentOnlyOwnerProxy(acuityItemDagOneParentOnlyOwner);
    }

    function testControlAddChildAlreadyHasParent() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemDagOneParentOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0002));
        acuityItemDagOneParentOnlyOwner.addChild(itemId1, acuityItemStore, bytes2(0x0003));
    }

    function testFailAddChildAlreadyHasParent() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemDagOneParentOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0002));
        acuityItemDagOneParentOnlyOwner.addChild(itemId1, acuityItemStore, bytes2(0x0002));
    }

    function testControlAddChildItemNotInUse() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemDagOneParentOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testFailAddChildItemNotInUse() public {
        bytes32 itemId0 = hex"";
        acuityItemDagOneParentOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testControlAddChildItemDifferentOwner() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemDagOneParentOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testFailAddChildItemDifferentOwner() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemDagOneParentOnlyOwnerProxy.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testControlAddChildChildExists() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemDagOneParentOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testFailAddChildChildExists() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemDagOneParentOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0001));
    }

    function testAddChild() public {
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");

        assertEq(acuityItemDagOneParentOnlyOwner.getChildCount(itemId0), 0);
        assertEq(acuityItemDagOneParentOnlyOwner.getAllChildIds(itemId0).length, 0);
        assert(!acuityItemDagOneParentOnlyOwner.getHasParent(itemId0));

        acuityItemDagOneParentOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0001));
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0001), hex"1234");

        assertEq(acuityItemDagOneParentOnlyOwner.getChildCount(itemId0), 1);
        bytes32[] memory childIds = acuityItemDagOneParentOnlyOwner.getAllChildIds(itemId0);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId1);
        assert(!acuityItemDagOneParentOnlyOwner.getHasParent(itemId0));

        assertEq(acuityItemDagOneParentOnlyOwner.getChildCount(itemId1), 0);
        assertEq(acuityItemDagOneParentOnlyOwner.getAllChildIds(itemId1).length, 0);
        assert(acuityItemDagOneParentOnlyOwner.getHasParent(itemId1));
        assertEq(acuityItemDagOneParentOnlyOwner.getParentId(itemId1), itemId0);

        acuityItemDagOneParentOnlyOwner.addChild(itemId0, acuityItemStore, bytes2(0x0002));
        bytes32 itemId2 = acuityItemStore.create(bytes2(0x0002), hex"1234");

        assertEq(acuityItemDagOneParentOnlyOwner.getChildCount(itemId0), 2);
        childIds = acuityItemDagOneParentOnlyOwner.getAllChildIds(itemId0);
        assertEq(childIds.length, 2);
        assertEq(childIds[0], itemId1);
        assertEq(childIds[1], itemId2);
        assert(!acuityItemDagOneParentOnlyOwner.getHasParent(itemId0));

        assertEq(acuityItemDagOneParentOnlyOwner.getChildCount(itemId1), 0);
        assertEq(acuityItemDagOneParentOnlyOwner.getAllChildIds(itemId1).length, 0);
        assert(acuityItemDagOneParentOnlyOwner.getHasParent(itemId1));
        assertEq(acuityItemDagOneParentOnlyOwner.getParentId(itemId1), itemId0);

        assertEq(acuityItemDagOneParentOnlyOwner.getChildCount(itemId2), 0);
        assertEq(acuityItemDagOneParentOnlyOwner.getAllChildIds(itemId2).length, 0);
        assert(acuityItemDagOneParentOnlyOwner.getHasParent(itemId2));
        assertEq(acuityItemDagOneParentOnlyOwner.getParentId(itemId2), itemId0);
    }

}
