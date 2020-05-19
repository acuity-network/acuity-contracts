pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "../mix-item-store/MixItemStoreRegistry.sol";
import "../mix-item-store/MixItemStoreIpfsSha256.sol";

import "./MixAccountItems.sol";
import "./MixAccountItemsProxy.sol";


contract MixAccountItemsTest is DSTest {

    MixItemStoreRegistry mixItemStoreRegistry;
    MixItemStoreIpfsSha256 mixItemStoreIpfsSha256;
    MixAccountItems mixAccountItems;
    MixAccountItemsProxy mixAccountItemsProxy;

    function setUp() public {
        mixItemStoreRegistry = new MixItemStoreRegistry();
        mixItemStoreIpfsSha256 = new MixItemStoreIpfsSha256(mixItemStoreRegistry);
        mixAccountItems = new MixAccountItems(mixItemStoreRegistry);
        mixAccountItemsProxy = new MixAccountItemsProxy(mixAccountItems);
    }

    function testControlAddItemAlreadyAdded() public {
        bytes32 itemId = mixItemStoreIpfsSha256.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
    }

    function testFailAddItemAlreadyAdded() public {
        bytes32 itemId = mixItemStoreIpfsSha256.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
        mixAccountItems.addItem(itemId);
    }

    function testControlAddItemNotOwner() public {
        bytes32 itemId = mixItemStoreIpfsSha256.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
    }

    function testFailAddItemNotOwner() public {
        bytes32 itemId = mixItemStoreIpfsSha256.create(hex"00", hex"1234");
        mixAccountItemsProxy.addItem(itemId);
    }

    function testControlRemoveItemNotAdded() public {
        bytes32 itemId = mixItemStoreIpfsSha256.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
        mixAccountItems.removeItem(itemId);
    }

    function testFailRemoveItemNotAdded() public {
        bytes32 itemId = mixItemStoreIpfsSha256.create(hex"00", hex"1234");
        mixAccountItems.removeItem(itemId);
    }

    function testControlRemoveItemNotOwner() public {
        bytes32 itemId = mixItemStoreIpfsSha256.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
        mixAccountItems.removeItem(itemId);
    }

    function testFailRemoveItemNotOwner() public {
        bytes32 itemId = mixItemStoreIpfsSha256.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
        mixAccountItemsProxy.removeItem(itemId);
    }

    function test() public {
        assertEq(mixAccountItems.getItemCount(), 0);
        bytes32[] memory itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 0);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 0);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 0);

        bytes32 itemId0 = mixItemStoreIpfsSha256.create(hex"0000", hex"1234");
        assertTrue(!mixAccountItems.getItemExists(itemId0));
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId0));
        mixAccountItems.addItem(itemId0);
        assertTrue(mixAccountItems.getItemExists(itemId0));
        assertEq(mixAccountItems.getItemCount(), 1);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId0));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 1);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);

        bytes32 itemId1 = mixItemStoreIpfsSha256.create(hex"0001", hex"1234");
        assertTrue(!mixAccountItems.getItemExists(itemId1));
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId1));
        mixAccountItems.addItem(itemId1);
        assertTrue(mixAccountItems.getItemExists(itemId1));
        assertEq(mixAccountItems.getItemCount(), 2);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId1));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 2);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);

        bytes32 itemId2 = mixItemStoreIpfsSha256.create(hex"0002", hex"1234");
        assertTrue(!mixAccountItems.getItemExists(itemId2));
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId2));
        mixAccountItems.addItem(itemId2);
        assertTrue(mixAccountItems.getItemExists(itemId2));
        assertEq(mixAccountItems.getItemCount(), 3);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId2));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 3);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);

        assertTrue(mixAccountItems.getItemExists(itemId0));
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId0));
        mixAccountItems.removeItem(itemId0);
        assertTrue(!mixAccountItems.getItemExists(itemId0));
        assertEq(mixAccountItems.getItemCount(), 2);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId0));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 2);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);

        mixAccountItems.addItem(itemId0);
        assertTrue(mixAccountItems.getItemExists(itemId0));
        assertEq(mixAccountItems.getItemCount(), 3);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId0);
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId0));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 3);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId0);

        mixAccountItems.removeItem(itemId0);
        assertTrue(!mixAccountItems.getItemExists(itemId0));
        assertEq(mixAccountItems.getItemCount(), 2);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId0));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 2);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);

        assertTrue(mixAccountItems.getItemExists(itemId1));
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId1));
        mixAccountItems.removeItem(itemId1);
        assertTrue(!mixAccountItems.getItemExists(itemId1));
        assertEq(mixAccountItems.getItemCount(), 1);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId2);
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId1));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 1);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId2);

        assertTrue(mixAccountItems.getItemExists(itemId2));
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId2));
        mixAccountItems.removeItem(itemId2);
        assertTrue(!mixAccountItems.getItemExists(itemId2));
        assertEq(mixAccountItems.getItemCount(), 0);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 0);
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId2));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 0);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 0);

        assertTrue(!mixAccountItems.getItemExists(itemId0));
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId0));
        mixAccountItems.addItem(itemId0);
        assertTrue(mixAccountItems.getItemExists(itemId0));
        assertEq(mixAccountItems.getItemCount(), 1);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId0));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 1);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);

        assertTrue(!mixAccountItems.getItemExists(itemId1));
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId1));
        mixAccountItems.addItem(itemId1);
        assertTrue(mixAccountItems.getItemExists(itemId1));
        assertEq(mixAccountItems.getItemCount(), 2);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId1));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 2);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);

        assertTrue(!mixAccountItems.getItemExists(itemId2));
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId2));
        mixAccountItems.addItem(itemId2);
        assertTrue(mixAccountItems.getItemExists(itemId2));
        assertEq(mixAccountItems.getItemCount(), 3);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId2));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 3);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);

        assertTrue(mixAccountItems.getItemExists(itemId0));
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId0));
        mixAccountItems.removeItem(itemId0);
        assertTrue(!mixAccountItems.getItemExists(itemId0));
        assertEq(mixAccountItems.getItemCount(), 2);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId0));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 2);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);

        assertTrue(mixAccountItems.getItemExists(itemId2));
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId2));
        mixAccountItems.removeItem(itemId2);
        assertTrue(!mixAccountItems.getItemExists(itemId2));
        assertEq(mixAccountItems.getItemCount(), 1);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId1);
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId2));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 1);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId1);

        assertTrue(mixAccountItems.getItemExists(itemId1));
        assertTrue(mixAccountItems.getItemExistsByAccount(address(this), itemId1));
        mixAccountItems.removeItem(itemId1);
        assertTrue(!mixAccountItems.getItemExists(itemId1));
        assertEq(mixAccountItems.getItemCount(), 0);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 0);
        assertTrue(!mixAccountItems.getItemExistsByAccount(address(this), itemId1));
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 0);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 0);
    }

}
