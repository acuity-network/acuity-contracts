// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";
import "./AcuityTokenBase.sol";


contract AcuityTokenBaseTest is DSTest {

    AcuityTokenItemRegistry acuityTokenRegistry;
    Token token;
    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStore;
    AcuityTokenBaseMockAccount mockAccount;

    function setUp() public {
        token = new Token('a', 'A');
        mockAccount = new AcuityTokenBaseMockAccount(token);
    }

    function testConstants() public {
        assertEq0(bytes(token.symbol()), bytes('a'));
        assertEq0(bytes(token.name()), bytes('A'));
        assertEq(token.decimals(), 18);
        assertEq(token.totalSupply(), 10);
    }

    function testControlTransferInsufficientBalance() public {
        token.transfer(address(0x1234), 10);
    }

    function testFailTransferInsufficientBalance() public {
        token.transfer(address(0x1234), 11);
    }

    function testTransfer() public {
        assertEq(token.balanceOf(address(this)), 10);
        assertEq(token.balanceOf(address(0x1234)), 0);
        assertEq(token.balanceOf(address(0x2345)), 0);
        assertTrue(token.transfer(address(0x1234), 5));
        assertEq(token.balanceOf(address(this)), 5);
        assertEq(token.balanceOf(address(0x1234)), 5);
        assertEq(token.balanceOf(address(0x2345)), 0);
        assertTrue(token.transfer(address(0x1234), 2));
        assertEq(token.balanceOf(address(this)), 3);
        assertEq(token.balanceOf(address(0x1234)), 7);
        assertEq(token.balanceOf(address(0x2345)), 0);
        assertTrue(token.transfer(address(0x2345), 1));
        assertEq(token.balanceOf(address(this)), 2);
        assertEq(token.balanceOf(address(0x1234)), 7);
        assertEq(token.balanceOf(address(0x2345)), 1);
        assertTrue(token.transfer(address(0x2345), 2));
        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(address(0x1234)), 7);
        assertEq(token.balanceOf(address(0x2345)), 3);
    }

    function testControlTransferFromNotAuthorized() public {
        mockAccount.authorize(address(this));
        token.transfer(address(mockAccount), 5);
        token.transferFrom(address(mockAccount), address(this), 5);
    }

    function testFailTransferFromNotAuthorized() public {
        token.transfer(address(mockAccount), 5);
        token.transferFrom(address(mockAccount), address(this), 5);
    }

    function testControlTransferFromInsufficientBalance() public {
        mockAccount.authorize(address(this));
        token.transfer(address(mockAccount), 5);
        token.transferFrom(address(mockAccount), address(this), 5);
    }

    function testFailTransferFromInsufficientBalance() public {
        mockAccount.authorize(address(this));
        token.transferFrom(address(mockAccount), address(this), 5);
    }

    function testTransferFrom() public {
        assertEq(token.balanceOf(address(this)), 10);
        assertEq(token.balanceOf(address(mockAccount)), 0);
        assertEq(token.balanceOf(address(0x1234)), 0);
        assertTrue(!token.getAccountAuthorized(address(mockAccount), address(this)));
        mockAccount.authorize(address(this));
        assertTrue(token.getAccountAuthorized(address(mockAccount), address(this)));
        assertTrue(token.transfer(address(mockAccount), 10));
        assertEq(token.balanceOf(address(mockAccount)), 10);
        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(address(0x1234)), 0);
        assertTrue(token.transferFrom(address(mockAccount), address(this), 3));
        assertEq(token.balanceOf(address(mockAccount)), 7);
        assertEq(token.balanceOf(address(this)), 3);
        assertEq(token.balanceOf(address(0x1234)), 0);
        assertTrue(token.transferFrom(address(mockAccount), address(0x1234), 5));
        assertEq(token.balanceOf(address(mockAccount)), 2);
        assertEq(token.balanceOf(address(this)), 3);
        assertEq(token.balanceOf(address(0x1234)), 5);
        assertTrue(token.transferFrom(address(mockAccount), address(this), 2));
        assertEq(token.balanceOf(address(mockAccount)), 0);
        assertEq(token.balanceOf(address(this)), 5);
        assertEq(token.balanceOf(address(0x1234)), 5);
    }

}


contract Token is AcuityTokenInterface, AcuityTokenBase {

    constructor(string memory symbol, string memory name) AcuityTokenBase(symbol, name)
    {
        accountBalance[msg.sender] = 10;
    }

    function totalSupply() override external pure returns (uint) {
        return 10;
    }

}


contract AcuityTokenBaseMockAccount {

    AcuityTokenBase token;

    constructor(AcuityTokenBase _token) {
        token = _token;
    }

    function authorize(address account) public {
        token.authorize(account);
    }

    function unauthorize(address account) public {
        token.unauthorize(account);
    }

}
