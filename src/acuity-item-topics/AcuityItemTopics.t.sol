// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreRegistry.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";

import "./AcuityItemTopics.sol";

contract AcuityItemTopicsTest is DSTest {

    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStore;
    AcuityItemTopics acuityItemTopics;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStore = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        acuityItemTopics = new AcuityItemTopics();
    }

    function testCreateTopic() public {
        bytes32 topicHash1 = acuityItemTopics.createTopic("topic1");
        assertEq(topicHash1, acuityItemTopics.createTopic("topic1"));
        assertEq0(bytes(acuityItemTopics.getTopic(topicHash1)), bytes("topic1"));

        bytes32 topicHash2 = acuityItemTopics.createTopic("topic2");
        assertEq(topicHash1, acuityItemTopics.createTopic("topic1"));
        assertEq0(bytes(acuityItemTopics.getTopic(topicHash1)), bytes("topic1"));
        assertEq(topicHash2, acuityItemTopics.createTopic("topic2"));
        assertEq0(bytes(acuityItemTopics.getTopic(topicHash2)), bytes("topic2"));

        bytes32 topicHash3 = acuityItemTopics.createTopic("topic3");
        assertEq(topicHash1, acuityItemTopics.createTopic("topic1"));
        assertEq0(bytes(acuityItemTopics.getTopic(topicHash1)), bytes("topic1"));
        assertEq(topicHash2, acuityItemTopics.createTopic("topic2"));
        assertEq0(bytes(acuityItemTopics.getTopic(topicHash2)), bytes("topic2"));
        assertEq(topicHash3, acuityItemTopics.createTopic("topic3"));
        assertEq0(bytes(acuityItemTopics.getTopic(topicHash3)), bytes("topic3"));

        bytes32 topicHash4 = acuityItemTopics.createTopic("topic4");
        assertEq(topicHash1, acuityItemTopics.createTopic("topic1"));
        assertEq0(bytes(acuityItemTopics.getTopic(topicHash1)), bytes("topic1"));
        assertEq(topicHash2, acuityItemTopics.createTopic("topic2"));
        assertEq0(bytes(acuityItemTopics.getTopic(topicHash2)), bytes("topic2"));
        assertEq(topicHash3, acuityItemTopics.createTopic("topic3"));
        assertEq0(bytes(acuityItemTopics.getTopic(topicHash3)), bytes("topic3"));
        assertEq(topicHash4, acuityItemTopics.createTopic("topic4"));
        assertEq0(bytes(acuityItemTopics.getTopic(topicHash4)), bytes("topic4"));
    }

    function testControlAddItemTopicDoesntExist() public {
        bytes32 topicHash = acuityItemTopics.createTopic("topic0");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0000));
    }

    function testFailAddItemTopicDoesntExist() public {
        bytes32 topicHash = hex"1234";
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0000));
    }

    function testControlAddItemAlreadyExists() public {
        bytes32 topicHash = acuityItemTopics.createTopic("topic0");
        acuityItemStore.create(bytes2(0x0002), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0001));
    }

    function testFailAddItemAlreadyExists() public {
        bytes32 topicHash = acuityItemTopics.createTopic("topic0");
        acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0001));
    }

    function testControlAddItemTooManyTopics() public {
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic00"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic01"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic02"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic03"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic04"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic05"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic06"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic07"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic08"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic09"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic10"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic11"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic12"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic13"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic14"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic15"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic16"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic17"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic18"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic19"), acuityItemStore, bytes2(0x0001));
    }

    function testFailAddItemTooManyTopics() public {
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic00"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic01"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic02"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic03"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic04"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic05"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic06"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic07"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic08"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic09"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic10"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic11"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic12"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic13"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic14"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic15"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic16"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic17"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic18"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic19"), acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(acuityItemTopics.createTopic("topic20"), acuityItemStore, bytes2(0x0001));
    }

    function testAddItem() public {
        bytes32 topicHash0 = acuityItemTopics.createTopic("topic0");
        assertEq0(bytes(acuityItemTopics.getTopic(topicHash0)), bytes("topic0"));
        acuityItemTopics.addItem(topicHash0, acuityItemStore, bytes2(0x0000));
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        assertEq(acuityItemTopics.getTopicItemCount(topicHash0), 1);
        assertEq(acuityItemTopics.getTopicItem(topicHash0, 0), itemId0);
        bytes32[] memory topicItems = acuityItemTopics.getAllTopicItems(topicHash0);
        assertEq(topicItems.length, 1);
        assertEq(topicItems[0], itemId0);
        assertEq(acuityItemTopics.getItemTopicCount(itemId0), 1);
        bytes32[] memory topicHashes = acuityItemTopics.getItemTopicHashes(itemId0);
        assertEq(topicHashes.length, 1);
        assertEq(topicHashes[0], topicHash0);

        acuityItemTopics.addItem(topicHash0, acuityItemStore, bytes2(0x0001));
        acuityItemTopics.addItem(topicHash0, acuityItemStore, bytes2(0x0002));
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0001), hex"1234");
        bytes32 itemId2 = acuityItemStore.create(bytes2(0x0002), hex"1234");
        assertEq(acuityItemTopics.getTopicItemCount(topicHash0), 3);
        assertEq(acuityItemTopics.getTopicItem(topicHash0, 0), itemId0);
        assertEq(acuityItemTopics.getTopicItem(topicHash0, 1), itemId1);
        assertEq(acuityItemTopics.getTopicItem(topicHash0, 2), itemId2);
        topicItems = acuityItemTopics.getAllTopicItems(topicHash0);
        assertEq(topicItems.length, 3);
        assertEq(topicItems[0], itemId0);
        assertEq(topicItems[1], itemId1);
        assertEq(topicItems[2], itemId2);
        assertEq(acuityItemTopics.getItemTopicCount(itemId1), 1);
        assertEq(acuityItemTopics.getItemTopicCount(itemId2), 1);
        topicHashes = acuityItemTopics.getItemTopicHashes(itemId1);
        assertEq(topicHashes.length, 1);
        assertEq(topicHashes[0], topicHash0);
        topicHashes = acuityItemTopics.getItemTopicHashes(itemId2);
        assertEq(topicHashes.length, 1);
        assertEq(topicHashes[0], topicHash0);

        bytes32 topicHash1 = acuityItemTopics.createTopic("topic1");
        assertEq0(bytes(acuityItemTopics.getTopic(topicHash1)), bytes("topic1"));
        acuityItemTopics.addItem(topicHash1, acuityItemStore, bytes2(0x0003));
        acuityItemTopics.addItem(topicHash1, acuityItemStore, bytes2(0x0004));
        bytes32 itemId3 = acuityItemStore.create(bytes2(0x0003), hex"1234");
        bytes32 itemId4 = acuityItemStore.create(bytes2(0x0004), hex"1234");
        assertEq(acuityItemTopics.getTopicItemCount(topicHash1), 2);
        assertEq(acuityItemTopics.getTopicItem(topicHash1, 0), itemId3);
        assertEq(acuityItemTopics.getTopicItem(topicHash1, 1), itemId4);
        topicItems = acuityItemTopics.getAllTopicItems(topicHash1);
        assertEq(topicItems.length, 2);
        assertEq(topicItems[0], itemId3);
        assertEq(topicItems[1], itemId4);
        assertEq(acuityItemTopics.getItemTopicCount(itemId3), 1);
        assertEq(acuityItemTopics.getItemTopicCount(itemId4), 1);
        topicHashes = acuityItemTopics.getItemTopicHashes(itemId3);
        assertEq(topicHashes.length, 1);
        assertEq(topicHashes[0], topicHash1);
        topicHashes = acuityItemTopics.getItemTopicHashes(itemId4);
        assertEq(topicHashes.length, 1);
        assertEq(topicHashes[0], topicHash1);
    }

    function testControlGetTopicDoesntExist() public {
        bytes32 topicHash = acuityItemTopics.createTopic("topic0");
        acuityItemTopics.getTopic(topicHash);
    }

    function testFailGetTopicDoesntExist() public view {
        bytes32 topicHash = hex"1234";
        acuityItemTopics.getTopic(topicHash);
    }

    function testControlGetTopicItemCountDoesntExist() public {
        bytes32 topicHash = acuityItemTopics.createTopic("topic0");
        acuityItemTopics.getTopicItemCount(topicHash);
    }

    function testFailGetTopicItemCountDoesntExist() public view {
        bytes32 topicHash = hex"1234";
        acuityItemTopics.getTopicItemCount(topicHash);
    }

    function testControlGetTopicItemDoesntExist() public {
        bytes32 topicHash = acuityItemTopics.createTopic("topic0");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0000));
        acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0001));
        acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0002));
        acuityItemStore.create(bytes2(0x0002), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0003));
        acuityItemStore.create(bytes2(0x0003), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0004));
        acuityItemStore.create(bytes2(0x0004), hex"1234");
        acuityItemTopics.getTopicItem(topicHash, 4);
    }

    function testFailGetTopicItemDoesntExist() public {
        bytes32 topicHash = acuityItemTopics.createTopic("topic0");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0000));
        acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0001));
        acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0002));
        acuityItemStore.create(bytes2(0x0002), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0003));
        acuityItemStore.create(bytes2(0x0003), hex"1234");
        acuityItemTopics.getTopicItem(topicHash, 4);
    }

    function testControlGetAllTopicItemsDoesntExist() public {
        bytes32 topicHash = acuityItemTopics.createTopic("topic0");
        acuityItemTopics.getAllTopicItems(topicHash);
    }

    function testFailGetAllTopicItemsDoesntExist() public view {
        bytes32 topicHash = hex"1234";
        acuityItemTopics.getAllTopicItems(topicHash);
    }

    function testControlGetTopicItemsByQueryDoesntExist() public {
        bytes32 topicHash = acuityItemTopics.createTopic("topic0");
        acuityItemTopics.getTopicItemsByQuery(topicHash, 0, 0);
    }

    function testFailGetTopicItemsByQueryDoesntExist() public view {
        bytes32 topicHash = hex"1234";
        acuityItemTopics.getTopicItemsByQuery(topicHash, 0, 0);
    }

    function testGetTopicItemsByQuery() public {
        bytes32 topicHash = acuityItemTopics.createTopic("topic");
        bytes32[] memory itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 0, 1);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 1, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 1, 1);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 0, 0);
        assertEq(itemIds.length, 0);

        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0000));
        bytes32 itemId0 = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0001));
        bytes32 itemId1 = acuityItemStore.create(bytes2(0x0001), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0002));
        bytes32 itemId2 = acuityItemStore.create(bytes2(0x0002), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0003));
        bytes32 itemId3 = acuityItemStore.create(bytes2(0x0003), hex"1234");
        acuityItemTopics.addItem(topicHash, acuityItemStore, bytes2(0x0004));
        bytes32 itemId4 = acuityItemStore.create(bytes2(0x0004), hex"1234");

        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 0, 100);
        assertEq(itemIds.length, 5);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(itemIds[4], itemId4);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 1, 100);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        assertEq(itemIds[3], itemId4);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 2, 100);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        assertEq(itemIds[2], itemId4);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 3, 100);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId3);
        assertEq(itemIds[1], itemId4);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 4, 100);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId4);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 5, 100);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 6, 100);
        assertEq(itemIds.length, 0);

        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 0, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 0, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 0, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 0, 3);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 0, 4);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 0, 5);
        assertEq(itemIds.length, 5);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(itemIds[4], itemId4);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 0, 6);
        assertEq(itemIds.length, 5);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(itemIds[4], itemId4);

        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 1, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 1, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId1);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 1, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 1, 3);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 1, 4);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        assertEq(itemIds[3], itemId4);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 1, 5);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId1);
        assertEq(itemIds[1], itemId2);
        assertEq(itemIds[2], itemId3);
        assertEq(itemIds[3], itemId4);

        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 2, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 2, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId2);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 2, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 2, 3);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        assertEq(itemIds[2], itemId4);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 2, 4);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId3);
        assertEq(itemIds[2], itemId4);

        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 3, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 3, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId3);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 3, 2);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId3);
        assertEq(itemIds[1], itemId4);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 3, 3);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId3);
        assertEq(itemIds[1], itemId4);

        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 4, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 4, 1);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId4);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 4, 2);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId4);

        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 5, 0);
        assertEq(itemIds.length, 0);
        itemIds = acuityItemTopics.getTopicItemsByQuery(topicHash, 5, 1);
        assertEq(itemIds.length, 0);
    }

}
