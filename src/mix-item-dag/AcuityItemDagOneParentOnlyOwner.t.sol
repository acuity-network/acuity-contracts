pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "../mix-item-store/AcuityItemStoreRegistry.sol";
import "../mix-item-store/AcuityItemStoreIpfsSha256.sol";

import "./AcuityItemDagOneParentOnlyOwner.sol";
import "./AcuityItemDagOneParentOnlyOwnerProxy.sol";


contract AcuityItemDagOneParentOnlyOwnerTest is DSTest {

    AcuityItemStoreRegistry mixItemStoreRegistry;
    AcuityItemStoreIpfsSha256 mixItemStore;
    AcuityItemDagOneParentOnlyOwner mixItemDagOneParentOnlyOwner;
    AcuityItemDagOneParentOnlyOwnerProxy mixItemDagOneParentOnlyOwnerProxy;

    function setUp() public {
        mixItemStoreRegistry = new AcuityItemStoreRegistry();
        mixItemStore = new AcuityItemStoreIpfsSha256(mixItemStoreRegistry);
        mixItemDagOneParentOnlyOwner = new AcuityItemDagOneParentOnlyOwner(mixItemStoreRegistry);
        mixItemDagOneParentOnlyOwnerProxy = new AcuityItemDagOneParentOnlyOwnerProxy(mixItemDagOneParentOnlyOwner);
    }

    function testControlAddChildAlreadyHasParent() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        bytes32 itemId1 = mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemDagOneParentOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0002));
        mixItemDagOneParentOnlyOwner.addChild(itemId1, mixItemStore, bytes2(0x0003));
    }

    function testFailAddChildAlreadyHasParent() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        bytes32 itemId1 = mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemDagOneParentOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0002));
        mixItemDagOneParentOnlyOwner.addChild(itemId1, mixItemStore, bytes2(0x0002));
    }

    function testControlAddChildItemNotInUse() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemDagOneParentOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testFailAddChildItemNotInUse() public {
        bytes32 itemId0 = hex"";
        mixItemDagOneParentOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testControlAddChildItemDifferentOwner() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemDagOneParentOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testFailAddChildItemDifferentOwner() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemDagOneParentOnlyOwnerProxy.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testControlAddChildChildExists() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemDagOneParentOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testFailAddChildChildExists() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemDagOneParentOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0001));
    }

    function testAddChild() public {
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");

        assertEq(mixItemDagOneParentOnlyOwner.getChildCount(itemId0), 0);
        assertEq(mixItemDagOneParentOnlyOwner.getAllChildIds(itemId0).length, 0);
        assert(!mixItemDagOneParentOnlyOwner.getHasParent(itemId0));

        mixItemDagOneParentOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0001));
        bytes32 itemId1 = mixItemStore.create(bytes2(0x0001), hex"1234");

        assertEq(mixItemDagOneParentOnlyOwner.getChildCount(itemId0), 1);
        bytes32[] memory childIds = mixItemDagOneParentOnlyOwner.getAllChildIds(itemId0);
        assertEq(childIds.length, 1);
        assertEq(childIds[0], itemId1);
        assert(!mixItemDagOneParentOnlyOwner.getHasParent(itemId0));

        assertEq(mixItemDagOneParentOnlyOwner.getChildCount(itemId1), 0);
        assertEq(mixItemDagOneParentOnlyOwner.getAllChildIds(itemId1).length, 0);
        assert(mixItemDagOneParentOnlyOwner.getHasParent(itemId1));
        assertEq(mixItemDagOneParentOnlyOwner.getParentId(itemId1), itemId0);

        mixItemDagOneParentOnlyOwner.addChild(itemId0, mixItemStore, bytes2(0x0002));
        bytes32 itemId2 = mixItemStore.create(bytes2(0x0002), hex"1234");

        assertEq(mixItemDagOneParentOnlyOwner.getChildCount(itemId0), 2);
        childIds = mixItemDagOneParentOnlyOwner.getAllChildIds(itemId0);
        assertEq(childIds.length, 2);
        assertEq(childIds[0], itemId1);
        assertEq(childIds[1], itemId2);
        assert(!mixItemDagOneParentOnlyOwner.getHasParent(itemId0));

        assertEq(mixItemDagOneParentOnlyOwner.getChildCount(itemId1), 0);
        assertEq(mixItemDagOneParentOnlyOwner.getAllChildIds(itemId1).length, 0);
        assert(mixItemDagOneParentOnlyOwner.getHasParent(itemId1));
        assertEq(mixItemDagOneParentOnlyOwner.getParentId(itemId1), itemId0);

        assertEq(mixItemDagOneParentOnlyOwner.getChildCount(itemId2), 0);
        assertEq(mixItemDagOneParentOnlyOwner.getAllChildIds(itemId2).length, 0);
        assert(mixItemDagOneParentOnlyOwner.getHasParent(itemId2));
        assertEq(mixItemDagOneParentOnlyOwner.getParentId(itemId2), itemId0);
    }

}
