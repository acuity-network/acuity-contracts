// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";
import "./AcuityCreatorToken.sol";
import "./AcuityTokenItemRegistry.sol";


contract AcuityTokenItemRegistryTest is DSTest {

    AcuityTokenItemRegistry acuityTokenRegistry;
    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStore;
    AcuityCreatorToken acuityCreatorToken;
    bytes32 itemId;
    AcuityTokenItemRegistryTestMockAccount mockAccount;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStore = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        itemId = acuityItemStore.create(hex"02", hex"1234");
        acuityTokenRegistry = new AcuityTokenItemRegistry(acuityItemStoreRegistry);
        acuityCreatorToken = new AcuityCreatorToken('a', 'A', address(this), 10, 1);
        mockAccount = new AcuityTokenItemRegistryTestMockAccount(acuityItemStore);
    }

    function testFailTokenNotOwnedBySender() public {
        AcuityCreatorToken token = new AcuityCreatorToken('a', 'A', address(0x1234), 10, 1);
        acuityTokenRegistry.register(token, itemId);
    }

    function testFailItemNotOwnedBySender() public {
        bytes32 _itemId = mockAccount.createItem();
        acuityTokenRegistry.register(acuityCreatorToken, _itemId);
    }

    function testFailItemNotEnforceRevisions() public {
        bytes32 _itemId = acuityItemStore.create(hex"00", hex"1234");
        acuityTokenRegistry.register(acuityCreatorToken, _itemId);
    }

    function testFailItemRetractable() public {
        bytes32 _itemId = acuityItemStore.create(hex"04", hex"1234");
        acuityTokenRegistry.register(acuityCreatorToken, _itemId);
    }

    function testFailTokenRegisteredBefore() public {
        acuityTokenRegistry.register(acuityCreatorToken, itemId);
        bytes32 _itemId = acuityItemStore.create(hex"02", hex"1234");
        acuityTokenRegistry.register(acuityCreatorToken, _itemId);
    }

    function testFailItemRegisteredBefore() public {
        acuityTokenRegistry.register(acuityCreatorToken, itemId);
        AcuityCreatorToken token = new AcuityCreatorToken('a', 'A', address(this), 10, 1);
        acuityTokenRegistry.register(token, itemId);
    }

    function testRegister() public {
        acuityTokenRegistry.register(acuityCreatorToken, itemId);
        assertEq(acuityTokenRegistry.getItemId(address(acuityCreatorToken)), itemId);
        assertEq(acuityTokenRegistry.getToken(itemId), address(acuityCreatorToken));
    }

    function testFailGetItemIdNotRegistered() public view {
        acuityTokenRegistry.getItemId(address(acuityCreatorToken));
    }

    function testFailGetTokenNotRegistered() public view {
        acuityTokenRegistry.getToken(itemId);
    }

}


contract AcuityTokenItemRegistryTestMockAccount {

    AcuityItemStoreIpfsSha256 acuityItemStore;

    constructor(AcuityItemStoreIpfsSha256 _acuityItemStore) {
        acuityItemStore = _acuityItemStore;
    }

    function createItem() public returns (bytes32) {
        return acuityItemStore.create(hex"02", hex"1234");
    }

}
