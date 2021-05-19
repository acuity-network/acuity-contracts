// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreRegistry.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";

import "./AcuityAccountItems.sol";
import "./AcuityAccountItemsProxy.sol";


contract AcuityAccountItemsTest is DSTest {

    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStoreIpfsSha256;
    AcuityAccountItems acuityAccountItems;
    AcuityAccountItemsProxy acuityAccountItemsProxy;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStoreIpfsSha256 = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        acuityAccountItems = new AcuityAccountItems(acuityItemStoreRegistry);
        acuityAccountItemsProxy = new AcuityAccountItemsProxy(acuityAccountItems);
    }

    function testControlAddItemAlreadyAdded() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(hex"00", hex"1234");
        acuityAccountItems.addItem(itemId);
    }

    function testFailAddItemAlreadyAdded() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(hex"00", hex"1234");
        acuityAccountItems.addItem(itemId);
        acuityAccountItems.addItem(itemId);
    }

    function testControlAddItemNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(hex"00", hex"1234");
        acuityAccountItems.addItem(itemId);
    }

    function testFailAddItemNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(hex"00", hex"1234");
        acuityAccountItemsProxy.addItem(itemId);
    }

    function testControlRemoveItemNotAdded() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(hex"00", hex"1234");
        acuityAccountItems.addItem(itemId);
        acuityAccountItems.removeItem(itemId);
    }

    function testFailRemoveItemNotAdded() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(hex"00", hex"1234");
        acuityAccountItems.removeItem(itemId);
    }

    function testControlRemoveItemNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(hex"00", hex"1234");
        acuityAccountItems.addItem(itemId);
        acuityAccountItems.removeItem(itemId);
    }

    function testFailRemoveItemNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(hex"00", hex"1234");
        acuityAccountItems.addItem(itemId);
        acuityAccountItemsProxy.removeItem(itemId);
    }

    function test() public {
        assertEq(acuityAccountItems.getItemCount(), 0);
        bytes32[] memory itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 0);
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 0);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 0);

        bytes32 itemId0 = acuityItemStoreIpfsSha256.create(hex"0000", hex"1234");
        assertTrue(!acuityAccountItems.getItemExists(itemId0));
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId0));
        acuityAccountItems.addItem(itemId0);
        assertTrue(acuityAccountItems.getItemExists(itemId0));
        assertEq(acuityAccountItems.getItemCount(), 1);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId0));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 1);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);

        bytes32 itemId1 = acuityItemStoreIpfsSha256.create(hex"0001", hex"1234");
        assertTrue(!acuityAccountItems.getItemExists(itemId1));
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId1));
        acuityAccountItems.addItem(itemId1);
        assertTrue(acuityAccountItems.getItemExists(itemId1));
        assertEq(acuityAccountItems.getItemCount(), 2);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId1));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 2);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);

        bytes32 itemId2 = acuityItemStoreIpfsSha256.create(hex"0002", hex"1234");
        assertTrue(!acuityAccountItems.getItemExists(itemId2));
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId2));
        acuityAccountItems.addItem(itemId2);
        assertTrue(acuityAccountItems.getItemExists(itemId2));
        assertEq(acuityAccountItems.getItemCount(), 3);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId2));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 3);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);

        assertTrue(acuityAccountItems.getItemExists(itemId0));
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId0));
        acuityAccountItems.removeItem(itemId0);
        assertTrue(!acuityAccountItems.getItemExists(itemId0));
        assertEq(acuityAccountItems.getItemCount(), 2);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId0));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 2);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);

        acuityAccountItems.addItem(itemId0);
        assertTrue(acuityAccountItems.getItemExists(itemId0));
        assertEq(acuityAccountItems.getItemCount(), 3);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId0);
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId0));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 3);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId0);

        acuityAccountItems.removeItem(itemId0);
        assertTrue(!acuityAccountItems.getItemExists(itemId0));
        assertEq(acuityAccountItems.getItemCount(), 2);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId0));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 2);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);

        assertTrue(acuityAccountItems.getItemExists(itemId1));
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId1));
        acuityAccountItems.removeItem(itemId1);
        assertTrue(!acuityAccountItems.getItemExists(itemId1));
        assertEq(acuityAccountItems.getItemCount(), 1);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId2);
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId1));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 1);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId2);

        assertTrue(acuityAccountItems.getItemExists(itemId2));
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId2));
        acuityAccountItems.removeItem(itemId2);
        assertTrue(!acuityAccountItems.getItemExists(itemId2));
        assertEq(acuityAccountItems.getItemCount(), 0);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 0);
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId2));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 0);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 0);

        assertTrue(!acuityAccountItems.getItemExists(itemId0));
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId0));
        acuityAccountItems.addItem(itemId0);
        assertTrue(acuityAccountItems.getItemExists(itemId0));
        assertEq(acuityAccountItems.getItemCount(), 1);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId0));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 1);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);

        assertTrue(!acuityAccountItems.getItemExists(itemId1));
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId1));
        acuityAccountItems.addItem(itemId1);
        assertTrue(acuityAccountItems.getItemExists(itemId1));
        assertEq(acuityAccountItems.getItemCount(), 2);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId1));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 2);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);

        assertTrue(!acuityAccountItems.getItemExists(itemId2));
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId2));
        acuityAccountItems.addItem(itemId2);
        assertTrue(acuityAccountItems.getItemExists(itemId2));
        assertEq(acuityAccountItems.getItemCount(), 3);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId2));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 3);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);

        assertTrue(acuityAccountItems.getItemExists(itemId0));
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId0));
        acuityAccountItems.removeItem(itemId0);
        assertTrue(!acuityAccountItems.getItemExists(itemId0));
        assertEq(acuityAccountItems.getItemCount(), 2);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId0));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 2);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);

        assertTrue(acuityAccountItems.getItemExists(itemId2));
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId2));
        acuityAccountItems.removeItem(itemId2);
        assertTrue(!acuityAccountItems.getItemExists(itemId2));
        assertEq(acuityAccountItems.getItemCount(), 1);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId1);
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId2));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 1);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId1);

        assertTrue(acuityAccountItems.getItemExists(itemId1));
        assertTrue(acuityAccountItems.getItemExistsByAccount(address(this), itemId1));
        acuityAccountItems.removeItem(itemId1);
        assertTrue(!acuityAccountItems.getItemExists(itemId1));
        assertEq(acuityAccountItems.getItemCount(), 0);
        itemIds = acuityAccountItems.getAllItems();
        assertEq(itemIds.length, 0);
        assertTrue(!acuityAccountItems.getItemExistsByAccount(address(this), itemId1));
        assertEq(acuityAccountItems.getItemCountByAccount(address(this)), 0);
        itemIds = acuityAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 0);
    }

}
