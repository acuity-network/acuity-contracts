pragma solidity ^0.5.12;

import "ds-test/test.sol";
import "mix-item-store/MixItemStoreIpfsSha256.sol";
import "./MixCreatorToken.sol";
import "./MixTokenItemRegistry.sol";


contract MixTokenItemRegistryTest is DSTest {

    MixTokenItemRegistry mixTokenRegistry;
    MixItemStoreRegistry mixItemStoreRegistry;
    MixItemStoreIpfsSha256 mixItemStore;
    MixCreatorToken mixCreatorToken;
    bytes32 itemId;
    MixTokenItemRegistryTestMockAccount mockAccount;

    function setUp() public {
        mixItemStoreRegistry = new MixItemStoreRegistry();
        mixItemStore = new MixItemStoreIpfsSha256(mixItemStoreRegistry);
        itemId = mixItemStore.create(hex"02", hex"1234");
        mixTokenRegistry = new MixTokenItemRegistry(mixItemStoreRegistry);
        mixCreatorToken = new MixCreatorToken('a', 'A', address(this), 10, 1);
        mockAccount = new MixTokenItemRegistryTestMockAccount(mixItemStore);
    }

    function testFailTokenNotOwnedBySender() public {
        MixCreatorToken token = new MixCreatorToken('a', 'A', address(0x1234), 10, 1);
        mixTokenRegistry.register(token, itemId);
    }

    function testFailItemNotOwnedBySender() public {
        bytes32 _itemId = mockAccount.createItem();
        mixTokenRegistry.register(mixCreatorToken, _itemId);
    }

    function testFailItemNotEnforceRevisions() public {
        bytes32 _itemId = mixItemStore.create(hex"00", hex"1234");
        mixTokenRegistry.register(mixCreatorToken, _itemId);
    }

    function testFailItemRetractable() public {
        bytes32 _itemId = mixItemStore.create(hex"04", hex"1234");
        mixTokenRegistry.register(mixCreatorToken, _itemId);
    }

    function testFailTokenRegisteredBefore() public {
        mixTokenRegistry.register(mixCreatorToken, itemId);
        bytes32 _itemId = mixItemStore.create(hex"02", hex"1234");
        mixTokenRegistry.register(mixCreatorToken, _itemId);
    }

    function testFailItemRegisteredBefore() public {
        mixTokenRegistry.register(mixCreatorToken, itemId);
        MixCreatorToken token = new MixCreatorToken('a', 'A', address(this), 10, 1);
        mixTokenRegistry.register(token, itemId);
    }

    function testRegister() public {
        mixTokenRegistry.register(mixCreatorToken, itemId);
        assertEq(mixTokenRegistry.getItemId(address(mixCreatorToken)), itemId);
        assertEq(mixTokenRegistry.getToken(itemId), address(mixCreatorToken));
    }

    function testFailGetItemIdNotRegistered() public view {
        mixTokenRegistry.getItemId(address(mixCreatorToken));
    }

    function testFailGetTokenNotRegistered() public view {
        mixTokenRegistry.getToken(itemId);
    }

}


contract MixTokenItemRegistryTestMockAccount {

    MixItemStoreIpfsSha256 mixItemStore;

    constructor(MixItemStoreIpfsSha256 _mixItemStore) public {
        mixItemStore = _mixItemStore;
    }

    function createItem() public returns (bytes32) {
        return mixItemStore.create(hex"02", hex"1234");
    }

}
