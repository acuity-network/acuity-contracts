pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "../mix-item-store/AcuityItemStoreIpfsSha256.sol";
import "./AcuityCreatorToken.sol";
import "./AcuityTokenItemRegistry.sol";


contract AcuityTokenItemRegistryTest is DSTest {

    AcuityTokenItemRegistry mixTokenRegistry;
    AcuityItemStoreRegistry mixItemStoreRegistry;
    AcuityItemStoreIpfsSha256 mixItemStore;
    AcuityCreatorToken mixCreatorToken;
    bytes32 itemId;
    AcuityTokenItemRegistryTestMockAccount mockAccount;

    function setUp() public {
        mixItemStoreRegistry = new AcuityItemStoreRegistry();
        mixItemStore = new AcuityItemStoreIpfsSha256(mixItemStoreRegistry);
        itemId = mixItemStore.create(hex"02", hex"1234");
        mixTokenRegistry = new AcuityTokenItemRegistry(mixItemStoreRegistry);
        mixCreatorToken = new AcuityCreatorToken('a', 'A', address(this), 10, 1);
        mockAccount = new AcuityTokenItemRegistryTestMockAccount(mixItemStore);
    }

    function testFailTokenNotOwnedBySender() public {
        AcuityCreatorToken token = new AcuityCreatorToken('a', 'A', address(0x1234), 10, 1);
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
        AcuityCreatorToken token = new AcuityCreatorToken('a', 'A', address(this), 10, 1);
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


contract AcuityTokenItemRegistryTestMockAccount {

    AcuityItemStoreIpfsSha256 mixItemStore;

    constructor(AcuityItemStoreIpfsSha256 _mixItemStore) public {
        mixItemStore = _mixItemStore;
    }

    function createItem() public returns (bytes32) {
        return mixItemStore.create(hex"02", hex"1234");
    }

}
