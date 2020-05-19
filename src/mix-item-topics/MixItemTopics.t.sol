pragma solidity ^0.5.11;

import "ds-test/test.sol";
import "mix-item-store/MixItemStoreRegistry.sol";
import "mix-item-store/MixItemStoreIpfsSha256.sol";

import "./MixItemTopics.sol";

contract MixItemTopicsTest is DSTest {

    MixItemStoreRegistry mixItemStoreRegistry;
    MixItemStoreIpfsSha256 mixItemStore;
    MixItemTopics mixItemTopics;

    function setUp() public {
        mixItemStoreRegistry = new MixItemStoreRegistry();
        mixItemStore = new MixItemStoreIpfsSha256(mixItemStoreRegistry);
        mixItemTopics = new MixItemTopics();
    }

    function testCreateTopic() public {
        bytes32 topicHash1 = mixItemTopics.createTopic("topic1");
        assertEq(topicHash1, mixItemTopics.createTopic("topic1"));
        assertEq0(bytes(mixItemTopics.getTopic(topicHash1)), bytes("topic1"));

        bytes32 topicHash2 = mixItemTopics.createTopic("topic2");
        assertEq(topicHash1, mixItemTopics.createTopic("topic1"));
        assertEq0(bytes(mixItemTopics.getTopic(topicHash1)), bytes("topic1"));
        assertEq(topicHash2, mixItemTopics.createTopic("topic2"));
        assertEq0(bytes(mixItemTopics.getTopic(topicHash2)), bytes("topic2"));

        bytes32 topicHash3 = mixItemTopics.createTopic("topic3");
        assertEq(topicHash1, mixItemTopics.createTopic("topic1"));
        assertEq0(bytes(mixItemTopics.getTopic(topicHash1)), bytes("topic1"));
        assertEq(topicHash2, mixItemTopics.createTopic("topic2"));
        assertEq0(bytes(mixItemTopics.getTopic(topicHash2)), bytes("topic2"));
        assertEq(topicHash3, mixItemTopics.createTopic("topic3"));
        assertEq0(bytes(mixItemTopics.getTopic(topicHash3)), bytes("topic3"));

        bytes32 topicHash4 = mixItemTopics.createTopic("topic4");
        assertEq(topicHash1, mixItemTopics.createTopic("topic1"));
        assertEq0(bytes(mixItemTopics.getTopic(topicHash1)), bytes("topic1"));
        assertEq(topicHash2, mixItemTopics.createTopic("topic2"));
        assertEq0(bytes(mixItemTopics.getTopic(topicHash2)), bytes("topic2"));
        assertEq(topicHash3, mixItemTopics.createTopic("topic3"));
        assertEq0(bytes(mixItemTopics.getTopic(topicHash3)), bytes("topic3"));
        assertEq(topicHash4, mixItemTopics.createTopic("topic4"));
        assertEq0(bytes(mixItemTopics.getTopic(topicHash4)), bytes("topic4"));
    }

    function testControlAddItemTopicDoesntExist() public {
        bytes32 topicHash = mixItemTopics.createTopic("topic0");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0000));
    }

    function testFailAddItemTopicDoesntExist() public {
        bytes32 topicHash = hex"1234";
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0000));
    }

    function testControlAddItemAlreadyExists() public {
        bytes32 topicHash = mixItemTopics.createTopic("topic0");
        mixItemStore.create(bytes2(0x0002), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0001));
    }

    function testFailAddItemAlreadyExists() public {
        bytes32 topicHash = mixItemTopics.createTopic("topic0");
        mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0001));
    }

    function testControlAddItemTooManyTopics() public {
        mixItemTopics.addItem(mixItemTopics.createTopic("topic00"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic01"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic02"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic03"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic04"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic05"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic06"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic07"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic08"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic09"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic10"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic11"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic12"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic13"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic14"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic15"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic16"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic17"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic18"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic19"), mixItemStore, bytes2(0x0001));
    }

    function testFailAddItemTooManyTopics() public {
        mixItemTopics.addItem(mixItemTopics.createTopic("topic00"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic01"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic02"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic03"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic04"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic05"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic06"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic07"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic08"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic09"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic10"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic11"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic12"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic13"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic14"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic15"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic16"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic17"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic18"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic19"), mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(mixItemTopics.createTopic("topic20"), mixItemStore, bytes2(0x0001));
    }

    function testAddItem() public {
        bytes32 topicHash0 = mixItemTopics.createTopic("topic0");
        assertEq0(bytes(mixItemTopics.getTopic(topicHash0)), bytes("topic0"));
        mixItemTopics.addItem(topicHash0, mixItemStore, bytes2(0x0000));
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        assertEq(mixItemTopics.getTopicItemCount(topicHash0), 1);
        assertEq(mixItemTopics.getTopicItem(topicHash0, 0), itemId0);
        bytes32[] memory topicItems = mixItemTopics.getAllTopicItems(topicHash0);
        assertEq(topicItems.length, 1);
        assertEq(topicItems[0], itemId0);
        assertEq(mixItemTopics.getItemTopicCount(itemId0), 1);
        bytes32[] memory topicHashes = mixItemTopics.getItemTopicHashes(itemId0);
        assertEq(topicHashes.length, 1);
        assertEq(topicHashes[0], topicHash0);

        mixItemTopics.addItem(topicHash0, mixItemStore, bytes2(0x0001));
        mixItemTopics.addItem(topicHash0, mixItemStore, bytes2(0x0002));
        bytes32 itemId1 = mixItemStore.create(bytes2(0x0001), hex"1234");
        bytes32 itemId2 = mixItemStore.create(bytes2(0x0002), hex"1234");
        assertEq(mixItemTopics.getTopicItemCount(topicHash0), 3);
        assertEq(mixItemTopics.getTopicItem(topicHash0, 0), itemId0);
        assertEq(mixItemTopics.getTopicItem(topicHash0, 1), itemId1);
        assertEq(mixItemTopics.getTopicItem(topicHash0, 2), itemId2);
        topicItems = mixItemTopics.getAllTopicItems(topicHash0);
        assertEq(topicItems.length, 3);
        assertEq(topicItems[0], itemId0);
        assertEq(topicItems[1], itemId1);
        assertEq(topicItems[2], itemId2);
        assertEq(mixItemTopics.getItemTopicCount(itemId1), 1);
        assertEq(mixItemTopics.getItemTopicCount(itemId2), 1);
        topicHashes = mixItemTopics.getItemTopicHashes(itemId1);
        assertEq(topicHashes.length, 1);
        assertEq(topicHashes[0], topicHash0);
        topicHashes = mixItemTopics.getItemTopicHashes(itemId2);
        assertEq(topicHashes.length, 1);
        assertEq(topicHashes[0], topicHash0);

        bytes32 topicHash1 = mixItemTopics.createTopic("topic1");
        assertEq0(bytes(mixItemTopics.getTopic(topicHash1)), bytes("topic1"));
        mixItemTopics.addItem(topicHash1, mixItemStore, bytes2(0x0003));
        mixItemTopics.addItem(topicHash1, mixItemStore, bytes2(0x0004));
        bytes32 itemId3 = mixItemStore.create(bytes2(0x0003), hex"1234");
        bytes32 itemId4 = mixItemStore.create(bytes2(0x0004), hex"1234");
        assertEq(mixItemTopics.getTopicItemCount(topicHash1), 2);
        assertEq(mixItemTopics.getTopicItem(topicHash1, 0), itemId3);
        assertEq(mixItemTopics.getTopicItem(topicHash1, 1), itemId4);
        topicItems = mixItemTopics.getAllTopicItems(topicHash1);
        assertEq(topicItems.length, 2);
        assertEq(topicItems[0], itemId3);
        assertEq(topicItems[1], itemId4);
        assertEq(mixItemTopics.getItemTopicCount(itemId3), 1);
        assertEq(mixItemTopics.getItemTopicCount(itemId4), 1);
        topicHashes = mixItemTopics.getItemTopicHashes(itemId3);
        assertEq(topicHashes.length, 1);
        assertEq(topicHashes[0], topicHash1);
        topicHashes = mixItemTopics.getItemTopicHashes(itemId4);
        assertEq(topicHashes.length, 1);
        assertEq(topicHashes[0], topicHash1);
    }

    function testControlGetTopicDoesntExist() public {
        bytes32 topicHash = mixItemTopics.createTopic("topic0");
        mixItemTopics.getTopic(topicHash);
    }

    function testFailGetTopicDoesntExist() public view {
        bytes32 topicHash = hex"1234";
        mixItemTopics.getTopic(topicHash);
    }

    function testControlGetTopicItemCountDoesntExist() public {
        bytes32 topicHash = mixItemTopics.createTopic("topic0");
        mixItemTopics.getTopicItemCount(topicHash);
    }

    function testFailGetTopicItemCountDoesntExist() public view {
        bytes32 topicHash = hex"1234";
        mixItemTopics.getTopicItemCount(topicHash);
    }

    function testControlGetTopicItemDoesntExist() public {
        bytes32 topicHash = mixItemTopics.createTopic("topic0");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0000));
        mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0001));
        mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0002));
        mixItemStore.create(bytes2(0x0002), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0003));
        mixItemStore.create(bytes2(0x0003), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0004));
        mixItemStore.create(bytes2(0x0004), hex"1234");
        mixItemTopics.getTopicItem(topicHash, 4);
    }

    function testFailGetTopicItemDoesntExist() public {
        bytes32 topicHash = mixItemTopics.createTopic("topic0");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0000));
        mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0001));
        mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0002));
        mixItemStore.create(bytes2(0x0002), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0003));
        mixItemStore.create(bytes2(0x0003), hex"1234");
        mixItemTopics.getTopicItem(topicHash, 4);
    }

    function testControlGetAllTopicItemsDoesntExist() public {
        bytes32 topicHash = mixItemTopics.createTopic("topic0");
        mixItemTopics.getAllTopicItems(topicHash);
    }

    function testFailGetAllTopicItemsDoesntExist() public view {
        bytes32 topicHash = hex"1234";
        mixItemTopics.getAllTopicItems(topicHash);
    }

    function testControlGetTopicItemsByQueryDoesntExist() public {
        bytes32 topicHash = mixItemTopics.createTopic("topic0");
        mixItemTopics.getTopicItemsByQuery(topicHash, 0, 0);
    }

    function testFailGetTopicItemsByQueryDoesntExist() public view {
        bytes32 topicHash = hex"1234";
        mixItemTopics.getTopicItemsByQuery(topicHash, 0, 0);
    }

    function testGetTopicItemsByQuery() public {
        bytes32 topicHash = mixItemTopics.createTopic("topic");
        bytes32[] memory itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 0, 1);
        assertEq(itemIds.length, 0);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 1, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 1, 1);
        assertEq(itemIds.length, 0);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 0, 0);
        assertEq(itemIds.length, 0);

        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0000));
        bytes32 itemId0 = mixItemStore.create(bytes2(0x0000), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0001));
        bytes32 itemId1 = mixItemStore.create(bytes2(0x0001), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0002));
        bytes32 itemId2 = mixItemStore.create(bytes2(0x0002), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0003));
        bytes32 itemId3 = mixItemStore.create(bytes2(0x0003), hex"1234");
        mixItemTopics.addItem(topicHash, mixItemStore, bytes2(0x0004));
        bytes32 itemId4 = mixItemStore.create(bytes2(0x0004), hex"1234");

        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 0, 100);
        assertEq(itemIds.length, 5);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(itemIds[4], itemId4);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 1, 100);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        assertEq(itemIds[3], itemId4);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 2, 100);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        assertEq(itemIds[2], itemId4);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 3, 100);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId3);
        assertEq(itemIds[1], itemId4);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 4, 100);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId4);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 5, 100);
        assertEq(itemIds.length, 0);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 6, 100);
        assertEq(itemIds.length, 0);

        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 0, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 0, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 0, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 0, 3);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 0, 4);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 0, 5);
        assertEq(itemIds.length, 5);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(itemIds[4], itemId4);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 0, 6);
        assertEq(itemIds.length, 5);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(itemIds[4], itemId4);

        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 1, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 1, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId1);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 1, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 1, 3);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 1, 4);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        assertEq(itemIds[3], itemId4);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 1, 5);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        assertEq(itemIds[3], itemId4);

        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 2, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 2, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId2);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 2, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 2, 3);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        assertEq(itemIds[2], itemId4);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 2, 4);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        assertEq(itemIds[2], itemId4);

        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 3, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 3, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId3);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 3, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId3);
        assertEq(itemIds[1], itemId4);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 3, 3);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId3);
        assertEq(itemIds[1], itemId4);

        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 4, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 4, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId4);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 4, 2);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId4);

        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 5, 0);
        assertEq(itemIds.length, 0);
        itemIds = mixItemTopics.getTopicItemsByQuery(topicHash, 5, 1);
        assertEq(itemIds.length, 0);
    }

}
