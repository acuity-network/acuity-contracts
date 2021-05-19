// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreRegistry.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";

import "./AcuityItemMentions.sol";


contract AcuityItemMentionsTest is DSTest {
    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStore;
    AcuityItemMentions acuityItemMentions;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStore = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        acuityItemMentions = new AcuityItemMentions();
    }

    function testControlAddItemAlreadyExists() public {
        acuityItemStore.create(bytes2(0x0002), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0001));
    }

    function testFailAddItemAlreadyExists() public {
        acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0001));
    }

    function testControlAddItemTooManyMentions() public {
        acuityItemMentions.addItem(address(0x0000), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0002), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0003), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0004), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0005), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0006), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0007), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0008), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0009), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0010), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0011), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0012), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0013), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0014), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0015), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0016), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0017), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0018), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0019), acuityItemStore, bytes2(0x0001));
    }

    function testFailAddItemTooManyMentions() public {
        acuityItemMentions.addItem(address(0x0000), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0002), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0003), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0004), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0005), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0006), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0007), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0008), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0009), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0010), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0011), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0012), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0013), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0014), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0015), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0016), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0017), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0018), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0019), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0020), acuityItemStore, bytes2(0x0001));
    }

    function testAddItem() public {
        acuityItemMentions.addItem(address(0x0000), acuityItemStore, bytes2(0x0000));
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        assertEq(acuityItemMentions.getMentionItemCount(address(0x0000)), 1);
        assertEq(acuityItemMentions.getMentionItem(address(0x0000), 0), itemId0);
        bytes32[] memory topicItems = acuityItemMentions.getAllMentionItems(address(0x0000));
        assertEq(topicItems.length, 1);
        assertEq(topicItems[0], itemId0);
        assertEq(acuityItemMentions.getItemMentionCount(itemId0), 1);
        address[] memory accounts = acuityItemMentions.getItemMentions(itemId0);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(0x0000));

        acuityItemMentions.addItem(address(0x0000), acuityItemStore, bytes2(0x0001));
        acuityItemMentions.addItem(address(0x0000), acuityItemStore, bytes2(0x0002));
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0001), hex"1234");
        bytes32 itemId2 = acuityItemStore.create(bytes2(0x0002), hex"1234");
        assertEq(acuityItemMentions.getMentionItemCount(address(0x0000)), 3);
        assertEq(acuityItemMentions.getMentionItem(address(0x0000), 0), itemId0);
        assertEq(acuityItemMentions.getMentionItem(address(0x0000), 1), itemId1);
        assertEq(acuityItemMentions.getMentionItem(address(0x0000), 2), itemId2);
        topicItems = acuityItemMentions.getAllMentionItems(address(0x0000));
        assertEq(topicItems.length, 3);
        assertEq(topicItems[0], itemId0);
        assertEq(topicItems[1], itemId1);
        assertEq(topicItems[2], itemId2);
        assertEq(acuityItemMentions.getItemMentionCount(itemId1), 1);
        assertEq(acuityItemMentions.getItemMentionCount(itemId2), 1);
        accounts = acuityItemMentions.getItemMentions(itemId1);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(0x0000));
        accounts = acuityItemMentions.getItemMentions(itemId2);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(0x0000));

        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0003));
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0004));
        bytes32 itemId3 = acuityItemStore.create(bytes2(0x0003), hex"1234");
        bytes32 itemId4 = acuityItemStore.create(bytes2(0x0004), hex"1234");
        assertEq(acuityItemMentions.getMentionItemCount(address(0x0001)), 2);
        assertEq(acuityItemMentions.getMentionItem(address(0x0001), 0), itemId3);
        assertEq(acuityItemMentions.getMentionItem(address(0x0001), 1), itemId4);
        topicItems = acuityItemMentions.getAllMentionItems(address(0x0001));
        assertEq(topicItems.length, 2);
        assertEq(topicItems[0], itemId3);
        assertEq(topicItems[1], itemId4);
        assertEq(acuityItemMentions.getItemMentionCount(itemId3), 1);
        assertEq(acuityItemMentions.getItemMentionCount(itemId4), 1);
        accounts = acuityItemMentions.getItemMentions(itemId3);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(0x0001));
        accounts = acuityItemMentions.getItemMentions(itemId4);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(0x0001));
    }

    function testControlGetMentionItemDoesntExist() public {
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0000));
        acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0001));
        acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0002));
        acuityItemStore.create(bytes2(0x0002), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0003));
        acuityItemStore.create(bytes2(0x0003), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0004));
        acuityItemStore.create(bytes2(0x0004), hex"1234");
        acuityItemMentions.getMentionItem(address(0x0001), 4);
    }

    function testFailGetMentionItemDoesntExist() public {
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0000));
        acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0001));
        acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0002));
        acuityItemStore.create(bytes2(0x0002), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0003));
        acuityItemStore.create(bytes2(0x0003), hex"1234");
        acuityItemMentions.getMentionItem(address(0x0001), 4);
    }

    function testGetMentionItemsByQuery() public {
        bytes32[] memory itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 0, 1);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 1, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 1, 1);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 0, 0);
        assertEq(itemIds.length, 0);

        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0000));
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0001));
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0002));
        bytes32 itemId2 = acuityItemStore.create(bytes2(0x0002), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0003));
        bytes32 itemId3 = acuityItemStore.create(bytes2(0x0003), hex"1234");
        acuityItemMentions.addItem(address(0x0001), acuityItemStore, bytes2(0x0004));
        bytes32 itemId4 = acuityItemStore.create(bytes2(0x0004), hex"1234");

        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 0, 100);
        assertEq(itemIds.length, 5);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(itemIds[4], itemId4);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 1, 100);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        assertEq(itemIds[3], itemId4);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 2, 100);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        assertEq(itemIds[2], itemId4);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 3, 100);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId3);
        assertEq(itemIds[1], itemId4);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 4, 100);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId4);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 5, 100);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 6, 100);
        assertEq(itemIds.length, 0);

        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 0, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 0, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 0, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 0, 3);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 0, 4);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 0, 5);
        assertEq(itemIds.length, 5);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(itemIds[4], itemId4);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 0, 6);
        assertEq(itemIds.length, 5);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(itemIds[4], itemId4);

        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 1, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 1, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId1);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 1, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 1, 3);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 1, 4);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        assertEq(itemIds[3], itemId4);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 1, 5);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        assertEq(itemIds[3], itemId4);

        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 2, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 2, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId2);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 2, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 2, 3);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        assertEq(itemIds[2], itemId4);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 2, 4);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        assertEq(itemIds[2], itemId4);

        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 3, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 3, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId3);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 3, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId3);
        assertEq(itemIds[1], itemId4);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 3, 3);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId3);
        assertEq(itemIds[1], itemId4);

        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 4, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 4, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId4);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 4, 2);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId4);

        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 5, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemMentions.getMentionItemsByQuery(address(0x0001), 5, 1);
        assertEq(itemIds.length, 0);
    }

}
