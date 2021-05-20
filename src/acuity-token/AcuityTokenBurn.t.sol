// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";
import "./AcuityCreatorToken.sol";
import "./AcuityTokenBurn.sol";


contract AccountProxy {

    AcuityTokenInterface token0;
    AcuityTokenInterface token1;
    AcuityTokenInterface token2;
    AcuityTokenInterface token3;
    AcuityTokenBurn acuityTokenBurn;
    AcuityItemStoreIpfsSha256 acuityItemStore;

    constructor (AcuityTokenInterface _token0, AcuityTokenInterface _token1, AcuityTokenInterface _token2, AcuityTokenInterface _token3, AcuityTokenBurn _acuityTokenBurn, AcuityItemStoreIpfsSha256 _acuityItemStore) {
        token0 = _token0;
        token1 = _token1;
        token2 = _token2;
        token3 = _token3;
        acuityTokenBurn = _acuityTokenBurn;
        acuityItemStore = _acuityItemStore;
    }

    function authorize(address account) external {
        token0.authorize(account);
        token1.authorize(account);
        token2.authorize(account);
        token3.authorize(account);
    }

    function getBurnTokenPrev(AcuityTokenInterface token, uint amount) external view returns (address prev, address oldPrev) {
        (prev, oldPrev) = acuityTokenBurn.getBurnTokenPrev(token, amount);
    }

    function getBurnItemPrev(bytes32 itemId, uint amount) external view returns (address tokenPrev, address tokenOldPrev, address itemPrev, address itemOldPrev) {
        (tokenPrev, tokenOldPrev, itemPrev, itemOldPrev) = acuityTokenBurn.getBurnItemPrev(itemId, amount);
    }

    function burnToken(AcuityTokenInterface token, uint amount, address prev, address oldPrev) external {
        acuityTokenBurn.burnToken(token, amount, prev, oldPrev);
    }

    function burnItem(bytes32 itemId, uint amount, address tokenPrev, address tokenOldPrev, address itemPrev, address itemOldPrev) external {
        acuityTokenBurn.burnItem(itemId, amount, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
    }

    function createItem(bytes32 flagsNonce, bytes32 ipfsHash) external returns (bytes32 itemId) {
        return acuityItemStore.create(flagsNonce, ipfsHash);
    }

}


contract AcuityTokenBurnTest is DSTest {

    AcuityTokenItemRegistry acuityTokenRegistry;
    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStore;
    AcuityTokenBurn acuityTokenBurn;

    AccountProxy account0;
    AccountProxy account1;
    AccountProxy account2;
    AccountProxy account3;

    AcuityCreatorToken token0;
    AcuityCreatorToken token1;
    AcuityCreatorToken token2;
    AcuityCreatorToken token3;

    bytes32 itemId0;
    bytes32 itemId1;
    bytes32 itemId2;
    bytes32 itemId3;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStore = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        acuityTokenRegistry = new AcuityTokenItemRegistry(acuityItemStoreRegistry);
        acuityTokenBurn = new AcuityTokenBurn(acuityItemStoreRegistry, acuityTokenRegistry);

        bytes32 itemId = acuityItemStore.create(hex"0200", hex"1234");
        token0 = new AcuityCreatorToken('a', 'A', address(this), 100, 0);
        acuityTokenRegistry.register(token0, itemId);

        // Items attached to token0
        itemId0 = acuityItemStore.create(hex"0210", hex"1234");
        acuityTokenBurn.setTokenToBurnItem(itemId0, token0);
        itemId1 = acuityItemStore.create(hex"0211", hex"1234");
        acuityTokenBurn.setTokenToBurnItem(itemId1, token0);
        itemId2 = acuityItemStore.create(hex"0212", hex"1234");
        acuityTokenBurn.setTokenToBurnItem(itemId2, token0);
        itemId3 = acuityItemStore.create(hex"0213", hex"1234");
        acuityTokenBurn.setTokenToBurnItem(itemId3, token0);

        itemId = acuityItemStore.create(hex"0201", hex"1234");
        token1 = new AcuityCreatorToken('a', 'A', address(this), 100, 0);
        acuityTokenRegistry.register(token1, itemId);
        itemId = acuityItemStore.create(hex"0202", hex"1234");
        token2 = new AcuityCreatorToken('a', 'A', address(this), 100, 0);
        acuityTokenRegistry.register(token2, itemId);
        itemId = acuityItemStore.create(hex"0203", hex"1234");
        token3 = new AcuityCreatorToken('a', 'A', address(this), 100, 0);
        acuityTokenRegistry.register(token3, itemId);

        account0 = new AccountProxy(token0, token1, token2, token3, acuityTokenBurn, acuityItemStore);
        account1 = new AccountProxy(token0, token1, token2, token3, acuityTokenBurn, acuityItemStore);
        account2 = new AccountProxy(token0, token1, token2, token3, acuityTokenBurn, acuityItemStore);
        account3 = new AccountProxy(token0, token1, token2, token3, acuityTokenBurn, acuityItemStore);

        token0.transfer(address(account0), 10);
        token0.transfer(address(account1), 10);
        token0.transfer(address(account2), 10);
        token0.transfer(address(account3), 10);

        token1.transfer(address(account0), 10);
        token2.transfer(address(account0), 10);
        token3.transfer(address(account0), 10);

        account0.authorize(address(acuityTokenBurn));
        account1.authorize(address(acuityTokenBurn));
        account2.authorize(address(acuityTokenBurn));
        account3.authorize(address(acuityTokenBurn));
    }

    function testControlBurnTokenZero() public {
        (address prev, address oldPrev) = account0.getBurnTokenPrev(token0, 1);
        account0.burnToken(token0, 1, prev, oldPrev);
    }

    function testFailBurnTokenZero() public {
        (address prev, address oldPrev) = account0.getBurnTokenPrev(token0, 0);
        account0.burnToken(token0, 0, prev, oldPrev);
    }

    function testControlBurnTokenNotEnough() public {
        (address prev, address oldPrev) = account0.getBurnTokenPrev(token0, 10);
        account0.burnToken(token0, 10, prev, oldPrev);
    }

    function testFailBurnTokenNotEnough() public {
        (address prev, address oldPrev) = account0.getBurnTokenPrev(token0, 11);
        account0.burnToken(token0, 11, prev, oldPrev);
    }

    function testControlBurnTokenOldPrevIncorrect() public {
        account0.burnToken(token0, 3, address(0), address(0));
        account1.burnToken(token0, 2, address(account0), address(0));
        account2.burnToken(token0, 1, address(account1), address(0));
        account1.burnToken(token0, 4, address(0), address(account0));
    }

    function testFailBurnTokenOldPrevIncorrect() public {
        account0.burnToken(token0, 3, address(0), address(0));
        account1.burnToken(token0, 2, address(account0), address(0));
        account2.burnToken(token0, 1, address(account1), address(0));
        account1.burnToken(token0, 4, address(0), address(account2));
    }

    function testControlBurnTokenNotLessThanOrEqualToPrev() public {
        account0.burnToken(token0, 3, address(0), address(0));
        account1.burnToken(token0, 3, address(account0), address(0));
    }

    function testFailBurnTokenNotLessThanOrEqualToPrev() public {
        account0.burnToken(token0, 3, address(0), address(0));
        account1.burnToken(token0, 4, address(account0), address(0));
    }

    function testControlSetTokenToBurnItemNotOwnedBySender() public {
        bytes32 itemId = acuityItemStore.create(hex"0220", hex"1234");
        acuityTokenBurn.setTokenToBurnItem(itemId, token0);
    }

    function testFailSetTokenToBurnItemNotOwnedBySender() public {
        bytes32 itemId = account0.createItem(hex"0220", hex"1234");
        acuityTokenBurn.setTokenToBurnItem(itemId, token0);
    }

    function testControlSetTokenToBurnTokenNotOwnedBySender() public {
        bytes32 itemId = acuityItemStore.create(hex"0220", hex"1234");
        AcuityCreatorToken token = new AcuityCreatorToken('a', 'A', address(this), 100, 0);
        acuityTokenBurn.setTokenToBurnItem(itemId, token);
    }

    function testFailSetTokenToBurnTokenNotOwnedBySender() public {
        bytes32 itemId = acuityItemStore.create(hex"0220", hex"1234");
        AcuityCreatorToken token = new AcuityCreatorToken('a', 'A', address(account0), 100, 0);
        acuityTokenBurn.setTokenToBurnItem(itemId, token);
    }

    function testControlSetTokenToBurnAlreadySet() public {
        bytes32 itemId = acuityItemStore.create(hex"0220", hex"1234");
        acuityTokenBurn.setTokenToBurnItem(itemId, token0);
    }

    function testFailSetTokenToBurnAlreadySet() public {
        bytes32 itemId = acuityItemStore.create(hex"0220", hex"1234");
        acuityTokenBurn.setTokenToBurnItem(itemId, token0);
        acuityTokenBurn.setTokenToBurnItem(itemId, token1);
    }

    function testBurnTokenMultipleAccounts() public {
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 0);

        assertEq(token0.balanceOf(address(account0)), 10);
        assertEq(token0.balanceOf(address(account1)), 10);
        assertEq(token0.balanceOf(address(account2)), 10);
        assertEq(token0.balanceOf(address(account3)), 10);

        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);

        (address prev, address oldPrev) = account0.getBurnTokenPrev(token0, 1);
        account0.burnToken(token0, 1, prev, oldPrev);
        assertEq(token0.balanceOf(address(account0)), 9);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);
        (address[] memory tokens, uint[] memory amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        address[] memory accounts;
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);

        (prev, oldPrev) = account1.getBurnTokenPrev(token0, 2);
        account1.burnToken(token0, 2, prev, oldPrev);
        assertEq(token0.balanceOf(address(account1)), 8);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 3);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 2);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 2);
        assertEq(accounts[0], address(account1));
        assertEq(accounts[1], address(account0));
        assertEq(amounts.length, 2);
        assertEq(amounts[0], 2);
        assertEq(amounts[1], 1);

        (prev, oldPrev) = account1.getBurnTokenPrev(token0, 2);
        account1.burnToken(token0, 2, prev, oldPrev);
        assertEq(token0.balanceOf(address(account1)), 6);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 5);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 4);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 2);
        assertEq(accounts[0], address(account1));
        assertEq(accounts[1], address(account0));
        assertEq(amounts.length, 2);
        assertEq(amounts[0], 4);
        assertEq(amounts[1], 1);

        (prev, oldPrev) = account2.getBurnTokenPrev(token0, 1);
        account2.burnToken(token0, 1, prev, oldPrev);
        assertEq(token0.balanceOf(address(account2)), 9);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 6);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 4);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 3);
        assertEq(accounts[0], address(account1));
        assertEq(accounts[1], address(account0));
        assertEq(accounts[2], address(account2));
        assertEq(amounts.length, 3);
        assertEq(amounts[0], 4);
        assertEq(amounts[1], 1);
        assertEq(amounts[2], 1);

        (prev, oldPrev) = account2.getBurnTokenPrev(token0, 8);
        account2.burnToken(token0, 8, prev, oldPrev);
        assertEq(token0.balanceOf(address(account2)), 1);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 14);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 4);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 9);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 3);
        assertEq(accounts[0], address(account2));
        assertEq(accounts[1], address(account1));
        assertEq(accounts[2], address(account0));
        assertEq(amounts.length, 3);
        assertEq(amounts[0], 9);
        assertEq(amounts[1], 4);
        assertEq(amounts[2], 1);

        (prev, oldPrev) = account0.getBurnTokenPrev(token0, 8);
        account0.burnToken(token0, 8, prev, oldPrev);
        assertEq(token0.balanceOf(address(account0)), 1);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 22);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 9);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 4);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 9);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 3);
        assertEq(accounts[0], address(account2));
        assertEq(accounts[1], address(account0));
        assertEq(accounts[2], address(account1));
        assertEq(amounts.length, 3);
        assertEq(amounts[0], 9);
        assertEq(amounts[1], 9);
        assertEq(amounts[2], 4);

        (prev, oldPrev) = account3.getBurnTokenPrev(token0, 5);
        account3.burnToken(token0, 5, prev, oldPrev);
        assertEq(token0.balanceOf(address(account3)), 5);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 27);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 9);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 4);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 9);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 5);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 5);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 4);
        assertEq(accounts[0], address(account2));
        assertEq(accounts[1], address(account0));
        assertEq(accounts[2], address(account3));
        assertEq(accounts[3], address(account1));
        assertEq(amounts.length, 4);
        assertEq(amounts[0], 9);
        assertEq(amounts[1], 9);
        assertEq(amounts[2], 5);
        assertEq(amounts[3], 4);
    }

    function testBurnItemMultipleAccounts() public {
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(acuityTokenBurn.getItemBurnedTotal(itemId0), 0);

        assertEq(token0.balanceOf(address(account0)), 10);
        assertEq(token0.balanceOf(address(account1)), 10);
        assertEq(token0.balanceOf(address(account2)), 10);
        assertEq(token0.balanceOf(address(account3)), 10);

        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);

        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account1)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account1), itemId0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account2)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account2), itemId0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account3), itemId0), 0);

        (address tokenPrev, address tokenOldPrev, address itemPrev, address itemOldPrev) = account0.getBurnItemPrev(itemId0, 1);
        account0.burnItem(itemId0, 1, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account0)), 9);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 1);
        assertEq(acuityTokenBurn.getItemBurnedTotal(itemId0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 1);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account1)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account1), itemId0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account2)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account2), itemId0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account3), itemId0), 0);
        (address[] memory tokens, uint[] memory amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        bytes32[] memory itemIds;
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account1), 0, 0);
        assertEq(itemIds.length, 0);
        assertEq(amounts.length, 0);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account2), 0, 0);
        assertEq(itemIds.length, 0);
        assertEq(amounts.length, 0);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account3), 0, 0);
        assertEq(itemIds.length, 0);
        assertEq(amounts.length, 0);
        address[] memory accounts;
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);

        (tokenPrev, tokenOldPrev, itemPrev, itemOldPrev) = account1.getBurnItemPrev(itemId0, 2);
        account1.burnItem(itemId0, 2, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account1)), 8);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 3);
        assertEq(acuityTokenBurn.getItemBurnedTotal(itemId0), 3);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 2);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 1);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account1), itemId0), 2);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account2)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account2), itemId0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account3), itemId0), 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account1), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account2), 0, 0);
        assertEq(itemIds.length, 0);
        assertEq(amounts.length, 0);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account3), 0, 0);
        assertEq(itemIds.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 2);
        assertEq(accounts[0], address(account1));
        assertEq(accounts[1], address(account0));
        assertEq(amounts.length, 2);
        assertEq(amounts[0], 2);
        assertEq(amounts[1], 1);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 2);
        assertEq(accounts[0], address(account1));
        assertEq(accounts[1], address(account0));
        assertEq(amounts.length, 2);
        assertEq(amounts[0], 2);
        assertEq(amounts[1], 1);

        (tokenPrev, tokenOldPrev, itemPrev, itemOldPrev) = account1.getBurnItemPrev(itemId0, 2);
        account1.burnItem(itemId0, 2, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account1)), 6);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 5);
        assertEq(acuityTokenBurn.getItemBurnedTotal(itemId0), 5);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 4);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 1);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account1), itemId0), 4);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account2)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account2), itemId0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account3), itemId0), 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account1), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account2), 0, 0);
        assertEq(itemIds.length, 0);
        assertEq(amounts.length, 0);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account3), 0, 0);
        assertEq(itemIds.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 2);
        assertEq(accounts[0], address(account1));
        assertEq(accounts[1], address(account0));
        assertEq(amounts.length, 2);
        assertEq(amounts[0], 4);
        assertEq(amounts[1], 1);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 2);
        assertEq(accounts[0], address(account1));
        assertEq(accounts[1], address(account0));
        assertEq(amounts.length, 2);
        assertEq(amounts[0], 4);
        assertEq(amounts[1], 1);

        (tokenPrev, tokenOldPrev, itemPrev, itemOldPrev) = account2.getBurnItemPrev(itemId0, 1);
        account2.burnItem(itemId0, 1, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account2)), 9);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 6);
        assertEq(acuityTokenBurn.getItemBurnedTotal(itemId0), 6);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 4);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 1);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account1), itemId0), 4);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account2)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account2), itemId0), 1);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account3), itemId0), 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account1), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account2), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account3), 0, 0);
        assertEq(itemIds.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 3);
        assertEq(accounts[0], address(account1));
        assertEq(accounts[1], address(account0));
        assertEq(accounts[2], address(account2));
        assertEq(amounts.length, 3);
        assertEq(amounts[0], 4);
        assertEq(amounts[1], 1);
        assertEq(amounts[2], 1);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 3);
        assertEq(accounts[0], address(account1));
        assertEq(accounts[1], address(account0));
        assertEq(accounts[2], address(account2));
        assertEq(amounts.length, 3);
        assertEq(amounts[0], 4);
        assertEq(amounts[1], 1);
        assertEq(amounts[2], 1);

        (tokenPrev, tokenOldPrev, itemPrev, itemOldPrev) = account2.getBurnItemPrev(itemId0, 8);
        account2.burnItem(itemId0, 8, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account2)), 1);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 14);
        assertEq(acuityTokenBurn.getItemBurnedTotal(itemId0), 14);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 4);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 9);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 1);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account1), itemId0), 4);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account2)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account2), itemId0), 9);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account3), itemId0), 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account1), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account2), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account3), 0, 0);
        assertEq(itemIds.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 3);
        assertEq(accounts[0], address(account2));
        assertEq(accounts[1], address(account1));
        assertEq(accounts[2], address(account0));
        assertEq(amounts.length, 3);
        assertEq(amounts[0], 9);
        assertEq(amounts[1], 4);
        assertEq(amounts[2], 1);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 3);
        assertEq(accounts[0], address(account2));
        assertEq(accounts[1], address(account1));
        assertEq(accounts[2], address(account0));
        assertEq(amounts.length, 3);
        assertEq(amounts[0], 9);
        assertEq(amounts[1], 4);
        assertEq(amounts[2], 1);

        (tokenPrev, tokenOldPrev, itemPrev, itemOldPrev) = account0.getBurnItemPrev(itemId0, 8);
        account0.burnItem(itemId0, 8, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account0)), 1);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 22);
        assertEq(acuityTokenBurn.getItemBurnedTotal(itemId0), 22);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 9);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 4);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 9);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 9);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account1), itemId0), 4);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account2)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account2), itemId0), 9);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account3)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account3), itemId0), 0);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 0);
        assertEq(amounts.length, 0);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account1), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account2), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account3), 0, 0);
        assertEq(itemIds.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 3);
        assertEq(accounts[0], address(account2));
        assertEq(accounts[1], address(account0));
        assertEq(accounts[2], address(account1));
        assertEq(amounts.length, 3);
        assertEq(amounts[0], 9);
        assertEq(amounts[1], 9);
        assertEq(amounts[2], 4);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 3);
        assertEq(accounts[0], address(account2));
        assertEq(accounts[1], address(account0));
        assertEq(accounts[2], address(account1));
        assertEq(amounts.length, 3);
        assertEq(amounts[0], 9);
        assertEq(amounts[1], 9);
        assertEq(amounts[2], 4);

        (tokenPrev, tokenOldPrev, itemPrev, itemOldPrev) = account3.getBurnItemPrev(itemId0, 5);
        account3.burnItem(itemId0, 5, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account3)), 5);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 27);
        assertEq(acuityTokenBurn.getItemBurnedTotal(itemId0), 27);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 9);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account1), token0), 4);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account2)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account2), token0), 9);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account3)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account3), token0), 5);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 9);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account1)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account1), itemId0), 4);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account2)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account2), itemId0), 9);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account3)), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account3), itemId0), 5);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account1), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account2), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account3), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 5);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account1), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account2), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account3), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 5);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 4);
        assertEq(accounts[0], address(account2));
        assertEq(accounts[1], address(account0));
        assertEq(accounts[2], address(account3));
        assertEq(accounts[3], address(account1));
        assertEq(amounts.length, 4);
        assertEq(amounts[0], 9);
        assertEq(amounts[1], 9);
        assertEq(amounts[2], 5);
        assertEq(amounts[3], 4);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 4);
        assertEq(accounts[0], address(account2));
        assertEq(accounts[1], address(account0));
        assertEq(accounts[2], address(account3));
        assertEq(accounts[3], address(account1));
        assertEq(amounts.length, 4);
        assertEq(amounts[0], 9);
        assertEq(amounts[1], 9);
        assertEq(amounts[2], 5);
        assertEq(amounts[3], 4);
    }

    function testBurnTokenMultipleTokens() public {
        assertEq(token0.balanceOf(address(account0)), 10);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(token1.balanceOf(address(account0)), 10);
        assertEq(token1.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(token2.balanceOf(address(account0)), 10);
        assertEq(token2.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(token3.balanceOf(address(account0)), 10);
        assertEq(token3.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token1), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token2), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token3), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 0);

        (address prev, address oldPrev) = account0.getBurnTokenPrev(token0, 1);
        account0.burnToken(token0, 1, prev, oldPrev);
        assertEq(token0.balanceOf(address(account0)), 9);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 1);
        assertEq(token1.balanceOf(address(account0)), 10);
        assertEq(token1.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(token2.balanceOf(address(account0)), 10);
        assertEq(token2.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(token3.balanceOf(address(account0)), 10);
        assertEq(token3.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token1), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token2), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token3), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        (address[] memory tokens, uint[] memory amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        address[] memory accounts;
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token1, 0, 10);
        assertEq(accounts.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token2, 0, 10);
        assertEq(accounts.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token3, 0, 10);
        assertEq(accounts.length, 0);
        assertEq(amounts.length, 0);

        (prev, oldPrev) = account0.getBurnTokenPrev(token1, 4);
        account0.burnToken(token1, 4, prev, oldPrev);
        assertEq(token0.balanceOf(address(account0)), 9);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 1);
        assertEq(token1.balanceOf(address(account0)), 6);
        assertEq(token1.balanceOf(address(acuityTokenBurn)), 4);
        assertEq(token2.balanceOf(address(account0)), 10);
        assertEq(token2.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(token3.balanceOf(address(account0)), 10);
        assertEq(token3.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token1), 4);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token2), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token3), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 2);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 2);
        assertEq(tokens[0], address(token0));
        assertEq(tokens[1], address(token1));
        assertEq(amounts.length, 2);
        assertEq(amounts[0], 1);
        assertEq(amounts[1], 4);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token1, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token2, 0, 10);
        assertEq(accounts.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token3, 0, 10);
        assertEq(accounts.length, 0);
        assertEq(amounts.length, 0);

        (prev, oldPrev) = account0.getBurnTokenPrev(token0, 4);
        account0.burnToken(token0, 4, prev, oldPrev);
        assertEq(token0.balanceOf(address(account0)), 5);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 5);
        assertEq(token1.balanceOf(address(account0)), 6);
        assertEq(token1.balanceOf(address(acuityTokenBurn)), 4);
        assertEq(token2.balanceOf(address(account0)), 10);
        assertEq(token2.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(token3.balanceOf(address(account0)), 10);
        assertEq(token3.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 5);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token1), 4);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token2), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token3), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 2);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 2);
        assertEq(tokens[0], address(token0));
        assertEq(tokens[1], address(token1));
        assertEq(amounts.length, 2);
        assertEq(amounts[0], 5);
        assertEq(amounts[1], 4);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 5);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token1, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token2, 0, 10);
        assertEq(accounts.length, 0);
        assertEq(amounts.length, 0);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token3, 0, 10);
        assertEq(accounts.length, 0);
        assertEq(amounts.length, 0);

        (prev, oldPrev) = account0.getBurnTokenPrev(token2, 10);
        account0.burnToken(token2, 10, prev, oldPrev);
        assertEq(token0.balanceOf(address(account0)), 5);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 5);
        assertEq(token1.balanceOf(address(account0)), 6);
        assertEq(token1.balanceOf(address(acuityTokenBurn)), 4);
        assertEq(token2.balanceOf(address(account0)), 0);
        assertEq(token2.balanceOf(address(acuityTokenBurn)), 10);
        assertEq(token3.balanceOf(address(account0)), 10);
        assertEq(token3.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 5);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token1), 4);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token2), 10);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token3), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 3);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 3);
        assertEq(tokens[0], address(token0));
        assertEq(tokens[1], address(token1));
        assertEq(tokens[2], address(token2));
        assertEq(amounts.length, 3);
        assertEq(amounts[0], 5);
        assertEq(amounts[1], 4);
        assertEq(amounts[2], 10);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 5);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token1, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token2, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 10);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token3, 0, 10);
        assertEq(accounts.length, 0);
        assertEq(amounts.length, 0);

        (prev, oldPrev) = account0.getBurnTokenPrev(token3, 1);
        account0.burnToken(token3, 1, prev, oldPrev);
        assertEq(token0.balanceOf(address(account0)), 5);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 5);
        assertEq(token1.balanceOf(address(account0)), 6);
        assertEq(token1.balanceOf(address(acuityTokenBurn)), 4);
        assertEq(token2.balanceOf(address(account0)), 0);
        assertEq(token2.balanceOf(address(acuityTokenBurn)), 10);
        assertEq(token3.balanceOf(address(account0)), 9);
        assertEq(token3.balanceOf(address(acuityTokenBurn)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 5);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token1), 4);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token2), 10);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token3), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 4);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 4);
        assertEq(tokens[0], address(token0));
        assertEq(tokens[1], address(token1));
        assertEq(tokens[2], address(token2));
        assertEq(tokens[3], address(token3));
        assertEq(amounts.length, 4);
        assertEq(amounts[0], 5);
        assertEq(amounts[1], 4);
        assertEq(amounts[2], 10);
        assertEq(amounts[3], 1);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 5);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token1, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token2, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 10);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token3, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);

        (prev, oldPrev) = account0.getBurnTokenPrev(token3, 1);
        account0.burnToken(token3, 1, prev, oldPrev);
        assertEq(token0.balanceOf(address(account0)), 5);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 5);
        assertEq(token1.balanceOf(address(account0)), 6);
        assertEq(token1.balanceOf(address(acuityTokenBurn)), 4);
        assertEq(token2.balanceOf(address(account0)), 0);
        assertEq(token2.balanceOf(address(acuityTokenBurn)), 10);
        assertEq(token3.balanceOf(address(account0)), 8);
        assertEq(token3.balanceOf(address(acuityTokenBurn)), 2);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 5);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token1), 4);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token2), 10);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token3), 2);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 4);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 4);
        assertEq(tokens[0], address(token0));
        assertEq(tokens[1], address(token1));
        assertEq(tokens[2], address(token2));
        assertEq(tokens[3], address(token3));
        assertEq(amounts.length, 4);
        assertEq(amounts[0], 5);
        assertEq(amounts[1], 4);
        assertEq(amounts[2], 10);
        assertEq(amounts[3], 2);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 5);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token1, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token2, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 10);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token3, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);
    }

    function testBurnItemMultipleItems() public {
        assertEq(token0.balanceOf(address(account0)), 10);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(token1.balanceOf(address(account0)), 10);
        assertEq(token1.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(token2.balanceOf(address(account0)), 10);
        assertEq(token2.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(token3.balanceOf(address(account0)), 10);
        assertEq(token3.balanceOf(address(acuityTokenBurn)), 0);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 0);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId1), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId2), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId3), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 0);

        (address tokenPrev, address tokenOldPrev, address itemPrev, address itemOldPrev) = account0.getBurnItemPrev(itemId0, 1);
        account0.burnItem(itemId0, 1, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account0)), 9);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 1);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 1);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        (address[] memory tokens, uint[] memory amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        address[] memory accounts;
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId1), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId2), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId3), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 1);
        bytes32[] memory itemIds;
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);

        (tokenPrev, tokenOldPrev, itemPrev, itemOldPrev) = account0.getBurnItemPrev(itemId1, 2);
        account0.burnItem(itemId1, 2, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account0)), 7);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 3);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 3);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 3);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 3);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 1);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId1), 2);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId2), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId3), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 2);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(amounts.length, 2);
        assertEq(amounts[0], 1);
        assertEq(amounts[1], 2);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 1);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId1, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);

        (tokenPrev, tokenOldPrev, itemPrev, itemOldPrev) = account0.getBurnItemPrev(itemId0, 1);
        account0.burnItem(itemId0, 1, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account0)), 6);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 4);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 4);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 4);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 2);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId1), 2);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId2), 0);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId3), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 2);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(amounts.length, 2);
        assertEq(amounts[0], 2);
        assertEq(amounts[1], 2);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId1, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);

        (tokenPrev, tokenOldPrev, itemPrev, itemOldPrev) = account0.getBurnItemPrev(itemId2, 3);
        account0.burnItem(itemId2, 3, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account0)), 3);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 7);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 7);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 7);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 7);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 2);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId1), 2);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId2), 3);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId3), 0);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 3);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(amounts.length, 3);
        assertEq(amounts[0], 2);
        assertEq(amounts[1], 2);
        assertEq(amounts[2], 3);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId1, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId2, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 3);

        (tokenPrev, tokenOldPrev, itemPrev, itemOldPrev) = account0.getBurnItemPrev(itemId3, 2);
        account0.burnItem(itemId3, 2, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account0)), 1);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 9);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 9);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 9);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 2);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId1), 2);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId2), 3);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId3), 2);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 4);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(amounts.length, 4);
        assertEq(amounts[0], 2);
        assertEq(amounts[1], 2);
        assertEq(amounts[2], 3);
        assertEq(amounts[3], 2);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId1, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId2, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 3);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId3, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);

        (tokenPrev, tokenOldPrev, itemPrev, itemOldPrev) = account0.getBurnItemPrev(itemId3, 1);
        account0.burnItem(itemId3, 1, tokenPrev, tokenOldPrev, itemPrev, itemOldPrev);
        assertEq(token0.balanceOf(address(account0)), 0);
        assertEq(token0.balanceOf(address(acuityTokenBurn)), 10);
        assertEq(acuityTokenBurn.getAccountTokenBurned(address(account0), token0), 10);
        assertEq(acuityTokenBurn.getAccountTokensBurnedCount(address(account0)), 1);
        (tokens, amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), 0, 0);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(token0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 10);
        (accounts, amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 10);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId0), 2);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId1), 2);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId2), 3);
        assertEq(acuityTokenBurn.getAccountItemBurned(address(account0), itemId3), 3);
        assertEq(acuityTokenBurn.getAccountItemsBurnedCount(address(account0)), 4);
        (itemIds, amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), 0, 0);
        assertEq(itemIds.length, 4);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(itemIds[3], itemId3);
        assertEq(amounts.length, 4);
        assertEq(amounts[0], 2);
        assertEq(amounts[1], 2);
        assertEq(amounts[2], 3);
        assertEq(amounts[3], 3);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId1, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 2);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId2, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 3);
        (accounts, amounts) = acuityTokenBurn.getItemAccountsBurned(itemId3, 0, 10);
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(account0));
        assertEq(amounts.length, 1);
        assertEq(amounts[0], 3);
    }

    function testControlGetTokenToBurnItemNoToken() public {
        bytes32 itemId = acuityItemStore.create(hex"0220", hex"1234");
        acuityTokenBurn.setTokenToBurnItem(itemId, token0);
        acuityTokenBurn.getTokenToBurnItem(itemId);
    }

    function testFailGetTokenToBurnItemNoToken() public {
        bytes32 itemId = acuityItemStore.create(hex"0220", hex"1234");
        acuityTokenBurn.getTokenToBurnItem(itemId);
    }

    function testGetTokenToBurnItem() public {
        bytes32 itemId = acuityItemStore.create(hex"0220", hex"1234");
        acuityTokenBurn.setTokenToBurnItem(itemId, token0);
        assertEq(address(acuityTokenBurn.getTokenToBurnItem(itemId)), address(token0));
    }

    function testGetItemsBurningTokenCount() public {
        assertEq(acuityTokenBurn.getItemsBurningTokenCount(token0), 4);
    }

    function testGetItemsBurningToken() public {
        bytes32[] memory inItems = new bytes32[](4);
        inItems[0] = itemId0;
        inItems[1] = itemId1;
        inItems[2] = itemId2;
        inItems[3] = itemId3;

        uint[] memory inAmounts = new uint[](4);
        inAmounts[0] = 4;
        inAmounts[1] = 3;
        inAmounts[2] = 2;
        inAmounts[3] = 1;

        for (uint i = 0; i < 4; i++) {
            account0.burnItem(inItems[i], inAmounts[i], address(0), address(0), address(0), address(0));
        }

        for (uint offset = 0; offset < 5; offset++) {
            for (uint limit = 0; limit < 6; limit++) {
                (bytes32[] memory items, uint[] memory amounts) = acuityTokenBurn.getItemsBurningToken(token0, offset, limit);
                uint length = 4 - offset;
                if (length < 0) length = 0;
                if (limit != 0 && length > limit) length = limit;
                assertEq(items.length, length);
                assertEq(amounts.length, length);

                for (uint i = 0; i < length; i++) {
                    assertEq(items[i], inItems[i + offset]);
                    assertEq(amounts[i], inAmounts[i + offset]);
                }
            }
        }
    }

    function testGetAccountTokensBurned() public {
        AcuityTokenInterface[] memory inTokens = new AcuityTokenInterface[](4);
        inTokens[0] = token0;
        inTokens[1] = token1;
        inTokens[2] = token2;
        inTokens[3] = token3;

        uint[] memory inAmounts = new uint[](4);
        inAmounts[0] = 4;
        inAmounts[1] = 3;
        inAmounts[2] = 2;
        inAmounts[3] = 1;

        for (uint i = 0; i < 4; i++) {
            account0.burnToken(inTokens[i], inAmounts[i], address(0), address(0));
        }

        for (uint offset = 0; offset < 5; offset++) {
            for (uint limit = 0; limit < 6; limit++) {
                (address[] memory tokens, uint[] memory amounts) = acuityTokenBurn.getAccountTokensBurned(address(account0), offset, limit);
                uint length = 4 - offset;
                if (length < 0) length = 0;
                if (limit != 0 && length > limit) length = limit;
                assertEq(tokens.length, length);
                assertEq(amounts.length, length);

                for (uint i = 0; i < length; i++) {
                    assertEq(tokens[i], address(inTokens[i + offset]));
                    assertEq(amounts[i], inAmounts[i + offset]);
                }
            }
        }
    }

    function testGetTokenAccountsBurned() public {
        address[] memory inAccounts = new address[](4);
        inAccounts[0] = address(account0);
        inAccounts[1] = address(account1);
        inAccounts[2] = address(account2);
        inAccounts[3] = address(account3);

        uint[] memory inAmounts = new uint[](4);
        inAmounts[0] = 4;
        inAmounts[1] = 3;
        inAmounts[2] = 2;
        inAmounts[3] = 1;

        account0.burnToken(token0, 4, address(0), address(0));
        account1.burnToken(token0, 3, address(account0), address(0));
        account2.burnToken(token0, 2, address(account1), address(0));
        account3.burnToken(token0, 1, address(account2), address(0));

        for (uint offset = 0; offset < 5; offset++) {
            for (uint limit = 0; limit < 6; limit++) {
                (address[] memory accounts, uint[] memory amounts) = acuityTokenBurn.getTokenAccountsBurned(token0, offset, limit);
                uint length = 4 - offset;
                if (length < 0) length = 0;
                if (length > limit) length = limit;
                assertEq(accounts.length, length);
                assertEq(amounts.length, length);

                for (uint i = 0; i < length; i++) {
                    assertEq(accounts[i], inAccounts[i + offset]);
                    assertEq(amounts[i], inAmounts[i + offset]);
                }
            }
        }
    }

    function testGetAccountItemsBurned() public {
        bytes32[] memory inItems = new bytes32[](4);
        inItems[0] = itemId0;
        inItems[1] = itemId1;
        inItems[2] = itemId2;
        inItems[3] = itemId3;

        uint[] memory inAmounts = new uint[](4);
        inAmounts[0] = 4;
        inAmounts[1] = 3;
        inAmounts[2] = 2;
        inAmounts[3] = 1;

        for (uint i = 0; i < 4; i++) {
            account0.burnItem(inItems[i], inAmounts[i], address(0), address(0), address(0), address(0));
        }

        for (uint offset = 0; offset < 5; offset++) {
            for (uint limit = 0; limit < 6; limit++) {
                (bytes32[] memory items, uint[] memory amounts) = acuityTokenBurn.getAccountItemsBurned(address(account0), offset, limit);
                uint length = 4 - offset;
                if (length < 0) length = 0;
                if (limit != 0 && length > limit) length = limit;
                assertEq(items.length, length);
                assertEq(amounts.length, length);

                for (uint i = 0; i < length; i++) {
                    assertEq(items[i], inItems[i + offset]);
                    assertEq(amounts[i], inAmounts[i + offset]);
                }
            }
        }
    }

    function testGetItemAccountsBurned() public {
        address[] memory inAccounts = new address[](4);
        inAccounts[0] = address(account0);
        inAccounts[1] = address(account1);
        inAccounts[2] = address(account2);
        inAccounts[3] = address(account3);

        uint[] memory inAmounts = new uint[](4);
        inAmounts[0] = 4;
        inAmounts[1] = 3;
        inAmounts[2] = 2;
        inAmounts[3] = 1;

        account0.burnItem(itemId0, 4, address(0), address(0), address(0), address(0));
        account1.burnItem(itemId0, 3, address(account0), address(0), address(account0), address(0));
        account2.burnItem(itemId0, 2, address(account1), address(0), address(account1), address(0));
        account3.burnItem(itemId0, 1, address(account2), address(0), address(account2), address(0));

        for (uint offset = 0; offset < 5; offset++) {
            for (uint limit = 0; limit < 6; limit++) {
                (address[] memory accounts, uint[] memory amounts) = acuityTokenBurn.getItemAccountsBurned(itemId0, offset, limit);
                uint length = 4 - offset;
                if (length < 0) length = 0;
                if (length > limit) length = limit;
                assertEq(accounts.length, length);
                assertEq(amounts.length, length);

                for (uint i = 0; i < length; i++) {
                    assertEq(accounts[i], inAccounts[i + offset]);
                    assertEq(amounts[i], inAmounts[i + offset]);
                }
            }
        }
    }

}
