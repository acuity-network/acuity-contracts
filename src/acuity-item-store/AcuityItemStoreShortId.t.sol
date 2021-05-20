// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "ds-test/test.sol";

import "./AcuityItemStoreShortId.sol";


contract AcuityItemStoreShortIdTest is DSTest {

    AcuityItemStoreShortId acuityItemStoreShortId;

    function setUp() public {
        acuityItemStoreShortId = new AcuityItemStoreShortId();
    }

    function testControlCreateShortIdAlreadyExists() public {
        acuityItemStoreShortId.createShortId(hex"1234");
        acuityItemStoreShortId.createShortId(hex"2345");
    }

    function testFailCreateShortIdAlreadyExists() public {
        acuityItemStoreShortId.createShortId(hex"1234");
        acuityItemStoreShortId.createShortId(hex"1234");
    }

    function testCreateShortId() public {
        bytes32 itemId0 = hex"1234";
        bytes32 itemId1 = hex"2345";
        bytes32 itemId2 = hex"3456";
        bytes32 itemId3 = hex"4567";

        bytes4 shortId0 = acuityItemStoreShortId.createShortId(itemId0);
        bytes4 shortId1 = acuityItemStoreShortId.createShortId(itemId1);
        bytes4 shortId2 = acuityItemStoreShortId.createShortId(itemId2);
        bytes4 shortId3 = acuityItemStoreShortId.createShortId(itemId3);

        assertTrue(shortId0 != shortId1);
        assertTrue(shortId0 != shortId2);
        assertTrue(shortId0 != shortId3);

        assertTrue(shortId1 != shortId2);
        assertTrue(shortId1 != shortId3);

        assertTrue(shortId2 != shortId3);

        assertEq(acuityItemStoreShortId.getItemId(shortId0), itemId0);
        assertEq(acuityItemStoreShortId.getShortId(itemId0), shortId0);

        assertEq(acuityItemStoreShortId.getItemId(shortId1), itemId1);
        assertEq(acuityItemStoreShortId.getShortId(itemId1), shortId1);

        assertEq(acuityItemStoreShortId.getItemId(shortId2), itemId2);
        assertEq(acuityItemStoreShortId.getShortId(itemId2), shortId2);

        assertEq(acuityItemStoreShortId.getItemId(shortId3), itemId3);
        assertEq(acuityItemStoreShortId.getShortId(itemId3), shortId3);
    }

}
