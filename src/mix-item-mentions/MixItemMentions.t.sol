pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "../mix-item-store/MixItemStoreRegistry.sol";
import "../mix-item-store/MixItemStoreIpfsSha256.sol";

import "./MixItemMentions.sol";


contract MixItemMentionsTest is DSTest {
    MixItemStoreRegistry mixItemStoreRegistry;
    MixItemStoreIpfsSha256 mixItemStore;
    MixItemMentions mixItemMentions;

    function setUp() public {
        mixItemStoreRegistry = new MixItemStoreRegistry();
        mixItemStore = new MixItemStoreIpfsSha256(mixItemStoreRegistry);
        mixItemMentions = new MixItemMentions();
    }

    function testControlAddItemAlreadyExists() public {
        mixItemStore.create(bytes2(0x0002), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0001));
    }

    function testFailAddItemAlreadyExists() public {
        mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0001));
    }

    function testControlAddItemTooManyMentions() public {
        mixItemMentions.addItem(address(0x0000), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0002), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0003), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0004), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0005), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0006), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0007), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0008), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0009), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0010), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0011), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0012), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0013), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0014), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0015), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0016), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0017), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0018), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0019), mixItemStore, bytes2(0x0001));
    }

    function testFailAddItemTooManyMentions() public {
        mixItemMentions.addItem(address(0x0000), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0002), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0003), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0004), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0005), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0006), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0007), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0008), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0009), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0010), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0011), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0012), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0013), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0014), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0015), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0016), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0017), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0018), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0019), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0020), mixItemStore, bytes2(0x0001));
    }

    function testAddItem() public {
        mixItemMentions.addItem(address(0x0000), mixItemStore, bytes2(0x0000));
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        assertEq(mixItemMentions.getMentionItemCount(address(0x0000)), 1);
        assertEq(mixItemMentions.getMentionItem(address(0x0000), 0), itemId0);
        bytes32[] memory topicItems = mixItemMentions.getAllMentionItems(address(0x0000));
        assertEq(topicItems.length, 1);
        assertEq(topicItems[0], itemId0);
        assertEq(mixItemMentions.getItemMentionCount(itemId0), 1);
        address[] memory accounts = mixItemMentions.getItemMentions(itemId0);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(0x0000));

        mixItemMentions.addItem(address(0x0000), mixItemStore, bytes2(0x0001));
        mixItemMentions.addItem(address(0x0000), mixItemStore, bytes2(0x0002));
        bytes32 itemId1 = mixItemStore.create(bytes2(0x0001), hex"1234");
        bytes32 itemId2 = mixItemStore.create(bytes2(0x0002), hex"1234");
        assertEq(mixItemMentions.getMentionItemCount(address(0x0000)), 3);
        assertEq(mixItemMentions.getMentionItem(address(0x0000), 0), itemId0);
        assertEq(mixItemMentions.getMentionItem(address(0x0000), 1), itemId1);
        assertEq(mixItemMentions.getMentionItem(address(0x0000), 2), itemId2);
        topicItems = mixItemMentions.getAllMentionItems(address(0x0000));
        assertEq(topicItems.length, 3);
        assertEq(topicItems[0], itemId0);
        assertEq(topicItems[1], itemId1);
        assertEq(topicItems[2], itemId2);
        assertEq(mixItemMentions.getItemMentionCount(itemId1), 1);
        assertEq(mixItemMentions.getItemMentionCount(itemId2), 1);
        accounts = mixItemMentions.getItemMentions(itemId1);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(0x0000));
        accounts = mixItemMentions.getItemMentions(itemId2);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(0x0000));

        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0003));
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0004));
        bytes32 itemId3 = mixItemStore.create(bytes2(0x0003), hex"1234");
        bytes32 itemId4 = mixItemStore.create(bytes2(0x0004), hex"1234");
        assertEq(mixItemMentions.getMentionItemCount(address(0x0001)), 2);
        assertEq(mixItemMentions.getMentionItem(address(0x0001), 0), itemId3);
        assertEq(mixItemMentions.getMentionItem(address(0x0001), 1), itemId4);
        topicItems = mixItemMentions.getAllMentionItems(address(0x0001));
        assertEq(topicItems.length, 2);
        assertEq(topicItems[0], itemId3);
        assertEq(topicItems[1], itemId4);
        assertEq(mixItemMentions.getItemMentionCount(itemId3), 1);
        assertEq(mixItemMentions.getItemMentionCount(itemId4), 1);
        accounts = mixItemMentions.getItemMentions(itemId3);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(0x0001));
        accounts = mixItemMentions.getItemMentions(itemId4);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(0x0001));
    }

    function testControlGetMentionItemDoesntExist() public {
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0000));
        mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0001));
        mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0002));
        mixItemStore.create(bytes2(0x0002), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0003));
        mixItemStore.create(bytes2(0x0003), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0004));
        mixItemStore.create(bytes2(0x0004), hex"1234");
        mixItemMentions.getMentionItem(address(0x0001), 4);
    }

    function testFailGetMentionItemDoesntExist() public {
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0000));
        mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0001));
        mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0002));
        mixItemStore.create(bytes2(0x0002), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0003));
        mixItemStore.create(bytes2(0x0003), hex"1234");
        mixItemMentions.getMentionItem(address(0x0001), 4);
    }

    function testGetMentionItemsByQuery() public {
        bytes32[] memory itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 0, 1);
        assertEq(itemIds.length, 0);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 1, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 1, 1);
        assertEq(itemIds.length, 0);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 0, 0);
        assertEq(itemIds.length, 0);

        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0000));
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0001));
        bytes32 itemId1 = mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0002));
        bytes32 itemId2 = mixItemStore.create(bytes2(0x0002), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0003));
        bytes32 itemId3 = mixItemStore.create(bytes2(0x0003), hex"1234");
        mixItemMentions.addItem(address(0x0001), mixItemStore, bytes2(0x0004));
        bytes32 itemId4 = mixItemStore.create(bytes2(0x0004), hex"1234");

        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 0, 100);
        assertEq(itemIds.length, 5);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(itemIds[4], itemId4);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 1, 100);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        assertEq(itemIds[3], itemId4);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 2, 100);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        assertEq(itemIds[2], itemId4);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 3, 100);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId3);
        assertEq(itemIds[1], itemId4);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 4, 100);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId4);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 5, 100);
        assertEq(itemIds.length, 0);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 6, 100);
        assertEq(itemIds.length, 0);

        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 0, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 0, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 0, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 0, 3);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 0, 4);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 0, 5);
        assertEq(itemIds.length, 5);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(itemIds[4], itemId4);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 0, 6);
        assertEq(itemIds.length, 5);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(itemIds[4], itemId4);

        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 1, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 1, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId1);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 1, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 1, 3);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 1, 4);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        assertEq(itemIds[3], itemId4);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 1, 5);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        assertEq(itemIds[3], itemId4);

        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 2, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 2, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId2);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 2, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 2, 3);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        assertEq(itemIds[2], itemId4);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 2, 4);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        assertEq(itemIds[2], itemId4);

        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 3, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 3, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId3);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 3, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId3);
        assertEq(itemIds[1], itemId4);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 3, 3);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId3);
        assertEq(itemIds[1], itemId4);

        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 4, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 4, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId4);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 4, 2);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId4);

        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 5, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemMentions.getMentionItemsByQuery(address(0x0001), 5, 1);
        assertEq(itemIds.length, 0);
    }

}
