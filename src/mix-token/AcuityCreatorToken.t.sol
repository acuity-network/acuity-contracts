pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "../mix-item-store/AcuityItemStoreIpfsSha256.sol";
import "./AcuityCreatorToken.sol";
import "./AcuityTokenBase.t.sol";


contract AcuityCreatorTokenTest is DSTest {

    AcuityTokenItemRegistry mixTokenRegistry;
    AcuityItemStoreRegistry mixItemStoreRegistry;
    AcuityItemStoreIpfsSha256 mixItemStore;
    AcuityCreatorToken mixCreatorToken;
    AcuityTokenBaseMockAccount mockAccount;

    function setUp() public {
        mixItemStoreRegistry = new AcuityItemStoreRegistry();
        mixItemStore = new AcuityItemStoreIpfsSha256(mixItemStoreRegistry);
        bytes32 itemId = mixItemStore.create(hex"02", hex"1234");
        mixTokenRegistry = new AcuityTokenItemRegistry(mixItemStoreRegistry);
        mixCreatorToken = new AcuityCreatorToken('a', 'A', address(this), 10, 1);
        mixTokenRegistry.register(mixCreatorToken, itemId);
        mockAccount = new AcuityTokenBaseMockAccount(mixCreatorToken);
    }

    function testConstants() public {
        assertEq0(bytes(mixCreatorToken.symbol()), bytes('a'));
        assertEq0(bytes(mixCreatorToken.name()), bytes('A'));
        assertEq(mixCreatorToken.decimals(), 18);
        assertEq(mixCreatorToken.totalSupply(), 10);
        assertEq(mixCreatorToken.start(), block.timestamp);
        assertEq(mixCreatorToken.owner(), address(this));
        assertEq(mixCreatorToken.initialBalance(), 10);
        assertEq(mixCreatorToken.dailyPayout(), 1);
    }

    function testControlInitialBalanceTooBig() public {
        new AcuityCreatorToken('a', 'A', address(this), uint224(-1) - 1, 0);
    }

    function testFailInitialBalanceTooBig() public {
        new AcuityCreatorToken('a', 'A', address(this), uint224(-1), 0);
    }

    function testControlDailyPayoutTooBig() public {
        new AcuityCreatorToken('a', 'A', address(this), 0, uint192(-1) - 1);
    }

    function testFailDailyPayoutTooBig() public {
        new AcuityCreatorToken('a', 'A', address(this), 0, uint192(-1));
    }

    function testControlTransferInsufficientBalance() public {
        mixCreatorToken.transfer(address(0x1234), 1);
    }

    function testFailTransferInsufficientBalance() public {
        mixCreatorToken.transfer(address(0x1234), 10);
        mixCreatorToken.transfer(address(0x1234), 1);
    }

    function testTransfer() public {
        assertEq(mixCreatorToken.balanceOf(address(this)), 10);
        assertEq(mixCreatorToken.balanceOf(address(0x1234)), 0);
        assertEq(mixCreatorToken.balanceOf(address(0x2345)), 0);
        assertTrue(mixCreatorToken.transfer(address(0x1234), 5));
        assertEq(mixCreatorToken.balanceOf(address(this)), 5);
        assertEq(mixCreatorToken.balanceOf(address(0x1234)), 5);
        assertEq(mixCreatorToken.balanceOf(address(0x2345)), 0);
        assertTrue(mixCreatorToken.transfer(address(0x1234), 2));
        assertEq(mixCreatorToken.balanceOf(address(this)), 3);
        assertEq(mixCreatorToken.balanceOf(address(0x1234)), 7);
        assertEq(mixCreatorToken.balanceOf(address(0x2345)), 0);
        assertTrue(mixCreatorToken.transfer(address(0x2345), 1));
        assertEq(mixCreatorToken.balanceOf(address(this)), 2);
        assertEq(mixCreatorToken.balanceOf(address(0x1234)), 7);
        assertEq(mixCreatorToken.balanceOf(address(0x2345)), 1);
        assertTrue(mixCreatorToken.transfer(address(0x2345), 2));
        assertEq(mixCreatorToken.balanceOf(address(this)), 0);
        assertEq(mixCreatorToken.balanceOf(address(0x1234)), 7);
        assertEq(mixCreatorToken.balanceOf(address(0x2345)), 3);
    }

    function testControlTransferFromNotAuthorized() public {
        mockAccount.authorize(address(this));
        mixCreatorToken.transfer(address(mockAccount), 5);
        mixCreatorToken.transferFrom(address(mockAccount), address(this), 5);
    }

    function testFailTransferFromNotAuthorized() public {
        mixCreatorToken.transfer(address(mockAccount), 5);
        mixCreatorToken.transferFrom(address(mockAccount), address(this), 5);
    }

    function testControlTransferFromInsufficientBalance() public {
        mockAccount.authorize(address(this));
        mixCreatorToken.transfer(address(mockAccount), 5);
        mixCreatorToken.transferFrom(address(mockAccount), address(this), 5);
    }

    function testFailTransferFromInsufficientBalance() public {
        mockAccount.authorize(address(this));
        mixCreatorToken.transferFrom(address(mockAccount), address(this), 5);
    }

    function testTransferFrom() public {
        assertEq(mixCreatorToken.balanceOf(address(this)), 10);
        assertEq(mixCreatorToken.balanceOf(address(mockAccount)), 0);
        assertEq(mixCreatorToken.balanceOf(address(0x1234)), 0);
        mockAccount.authorize(address(this));
        assertTrue(mixCreatorToken.transfer(address(mockAccount), 10));
        assertEq(mixCreatorToken.balanceOf(address(mockAccount)), 10);
        assertEq(mixCreatorToken.balanceOf(address(this)), 0);
        assertEq(mixCreatorToken.balanceOf(address(0x1234)), 0);
        assertTrue(mixCreatorToken.transferFrom(address(mockAccount), address(this), 3));
        assertEq(mixCreatorToken.balanceOf(address(mockAccount)), 7);
        assertEq(mixCreatorToken.balanceOf(address(this)), 3);
        assertEq(mixCreatorToken.balanceOf(address(0x1234)), 0);
        assertTrue(mixCreatorToken.transferFrom(address(mockAccount), address(0x1234), 5));
        assertEq(mixCreatorToken.balanceOf(address(mockAccount)), 2);
        assertEq(mixCreatorToken.balanceOf(address(this)), 3);
        assertEq(mixCreatorToken.balanceOf(address(0x1234)), 5);
        assertTrue(mixCreatorToken.transferFrom(address(mockAccount), address(this), 2));
        assertEq(mixCreatorToken.balanceOf(address(mockAccount)), 0);
        assertEq(mixCreatorToken.balanceOf(address(this)), 5);
        assertEq(mixCreatorToken.balanceOf(address(0x1234)), 5);
    }

    function testSupportsInterface() public {
        assertTrue(!mixCreatorToken.supportsInterface(0x00000000));
        assertTrue(!mixCreatorToken.supportsInterface(0xffffffff));
        assertTrue(mixCreatorToken.supportsInterface(0x01ffc9a7));    // ERC165
        assertTrue(mixCreatorToken.supportsInterface(new AcuityTokenInterfaceId().getInterfaceId()));
        assertTrue(mixCreatorToken.supportsInterface(new AcuityTokenOwnedInterfaceId().getInterfaceId()));
        assertTrue(mixCreatorToken.supportsInterface(new AcuityCreatorTokenInterfaceId().getInterfaceId()));
    }

}
