// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";
import "./AcuityCreatorToken.sol";
import "./AcuityTokenBase.t.sol";


contract AcuityCreatorTokenTest is DSTest {

    AcuityTokenItemRegistry acuityTokenRegistry;
    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStore;
    AcuityCreatorToken acuityCreatorToken;
    AcuityTokenBaseMockAccount mockAccount;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStore = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        bytes32 itemId = acuityItemStore.create(hex"02", hex"1234");
        acuityTokenRegistry = new AcuityTokenItemRegistry(acuityItemStoreRegistry);
        acuityCreatorToken = new AcuityCreatorToken('a', 'A', address(this), 10, 1);
        acuityTokenRegistry.register(acuityCreatorToken, itemId);
        mockAccount = new AcuityTokenBaseMockAccount(acuityCreatorToken);
    }

    function testConstants() public {
        assertEq0(bytes(acuityCreatorToken.symbol()), bytes('a'));
        assertEq0(bytes(acuityCreatorToken.name()), bytes('A'));
        assertEq(acuityCreatorToken.decimals(), 18);
        assertEq(acuityCreatorToken.totalSupply(), 10);
        assertEq(acuityCreatorToken.start(), block.timestamp);
        assertEq(acuityCreatorToken.owner(), address(this));
        assertEq(acuityCreatorToken.initialBalance(), 10);
        assertEq(acuityCreatorToken.dailyPayout(), 1);
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
        acuityCreatorToken.transfer(address(0x1234), 1);
    }

    function testFailTransferInsufficientBalance() public {
        acuityCreatorToken.transfer(address(0x1234), 10);
        acuityCreatorToken.transfer(address(0x1234), 1);
    }

    function testTransfer() public {
        assertEq(acuityCreatorToken.balanceOf(address(this)), 10);
        assertEq(acuityCreatorToken.balanceOf(address(0x1234)), 0);
        assertEq(acuityCreatorToken.balanceOf(address(0x2345)), 0);
        assertTrue(acuityCreatorToken.transfer(address(0x1234), 5));
        assertEq(acuityCreatorToken.balanceOf(address(this)), 5);
        assertEq(acuityCreatorToken.balanceOf(address(0x1234)), 5);
        assertEq(acuityCreatorToken.balanceOf(address(0x2345)), 0);
        assertTrue(acuityCreatorToken.transfer(address(0x1234), 2));
        assertEq(acuityCreatorToken.balanceOf(address(this)), 3);
        assertEq(acuityCreatorToken.balanceOf(address(0x1234)), 7);
        assertEq(acuityCreatorToken.balanceOf(address(0x2345)), 0);
        assertTrue(acuityCreatorToken.transfer(address(0x2345), 1));
        assertEq(acuityCreatorToken.balanceOf(address(this)), 2);
        assertEq(acuityCreatorToken.balanceOf(address(0x1234)), 7);
        assertEq(acuityCreatorToken.balanceOf(address(0x2345)), 1);
        assertTrue(acuityCreatorToken.transfer(address(0x2345), 2));
        assertEq(acuityCreatorToken.balanceOf(address(this)), 0);
        assertEq(acuityCreatorToken.balanceOf(address(0x1234)), 7);
        assertEq(acuityCreatorToken.balanceOf(address(0x2345)), 3);
    }

    function testControlTransferFromNotAuthorized() public {
        mockAccount.authorize(address(this));
        acuityCreatorToken.transfer(address(mockAccount), 5);
        acuityCreatorToken.transferFrom(address(mockAccount), address(this), 5);
    }

    function testFailTransferFromNotAuthorized() public {
        acuityCreatorToken.transfer(address(mockAccount), 5);
        acuityCreatorToken.transferFrom(address(mockAccount), address(this), 5);
    }

    function testControlTransferFromInsufficientBalance() public {
        mockAccount.authorize(address(this));
        acuityCreatorToken.transfer(address(mockAccount), 5);
        acuityCreatorToken.transferFrom(address(mockAccount), address(this), 5);
    }

    function testFailTransferFromInsufficientBalance() public {
        mockAccount.authorize(address(this));
        acuityCreatorToken.transferFrom(address(mockAccount), address(this), 5);
    }

    function testTransferFrom() public {
        assertEq(acuityCreatorToken.balanceOf(address(this)), 10);
        assertEq(acuityCreatorToken.balanceOf(address(mockAccount)), 0);
        assertEq(acuityCreatorToken.balanceOf(address(0x1234)), 0);
        mockAccount.authorize(address(this));
        assertTrue(acuityCreatorToken.transfer(address(mockAccount), 10));
        assertEq(acuityCreatorToken.balanceOf(address(mockAccount)), 10);
        assertEq(acuityCreatorToken.balanceOf(address(this)), 0);
        assertEq(acuityCreatorToken.balanceOf(address(0x1234)), 0);
        assertTrue(acuityCreatorToken.transferFrom(address(mockAccount), address(this), 3));
        assertEq(acuityCreatorToken.balanceOf(address(mockAccount)), 7);
        assertEq(acuityCreatorToken.balanceOf(address(this)), 3);
        assertEq(acuityCreatorToken.balanceOf(address(0x1234)), 0);
        assertTrue(acuityCreatorToken.transferFrom(address(mockAccount), address(0x1234), 5));
        assertEq(acuityCreatorToken.balanceOf(address(mockAccount)), 2);
        assertEq(acuityCreatorToken.balanceOf(address(this)), 3);
        assertEq(acuityCreatorToken.balanceOf(address(0x1234)), 5);
        assertTrue(acuityCreatorToken.transferFrom(address(mockAccount), address(this), 2));
        assertEq(acuityCreatorToken.balanceOf(address(mockAccount)), 0);
        assertEq(acuityCreatorToken.balanceOf(address(this)), 5);
        assertEq(acuityCreatorToken.balanceOf(address(0x1234)), 5);
    }

    function testSupportsInterface() public {
        assertTrue(!acuityCreatorToken.supportsInterface(0x00000000));
        assertTrue(!acuityCreatorToken.supportsInterface(0xffffffff));
        assertTrue(acuityCreatorToken.supportsInterface(0x01ffc9a7));    // ERC165
        assertTrue(acuityCreatorToken.supportsInterface(new AcuityTokenInterfaceId().getInterfaceId()));
        assertTrue(acuityCreatorToken.supportsInterface(new AcuityTokenOwnedInterfaceId().getInterfaceId()));
        assertTrue(acuityCreatorToken.supportsInterface(new AcuityCreatorTokenInterfaceId().getInterfaceId()));
    }

}
