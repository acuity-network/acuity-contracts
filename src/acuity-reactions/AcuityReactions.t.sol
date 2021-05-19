pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "../acuity-item-store/AcuityItemStoreRegistry.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";
import "../acuity-trusted-accounts/AcuityTrustedAccounts.sol";

import "./AcuityReactions.sol";
import "./AcuityReactionsProxy.sol";


contract AcuityReactionsTest is DSTest {

    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStore;
    AcuityTrustedAccounts acuityTrustedAccounts;
    AcuityReactions acuityReactions;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStore = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        acuityTrustedAccounts = new AcuityTrustedAccounts();
        acuityReactions = new AcuityReactions(acuityItemStoreRegistry, acuityTrustedAccounts);
    }

    function testControlReactTooMuch() public {
        bytes32 itemId = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityReactions.addReaction(itemId, hex"01");
        acuityReactions.addReaction(itemId, hex"02");
        acuityReactions.addReaction(itemId, hex"03");
        acuityReactions.addReaction(itemId, hex"04");
        acuityReactions.addReaction(itemId, hex"05");
        acuityReactions.addReaction(itemId, hex"06");
        acuityReactions.addReaction(itemId, hex"07");
        acuityReactions.addReaction(itemId, hex"08");
        acuityReactions.addReaction(itemId, hex"08");
    }

    function testFailReactTooMuch() public {
        bytes32 itemId = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityReactions.addReaction(itemId, hex"01");
        acuityReactions.addReaction(itemId, hex"02");
        acuityReactions.addReaction(itemId, hex"03");
        acuityReactions.addReaction(itemId, hex"04");
        acuityReactions.addReaction(itemId, hex"05");
        acuityReactions.addReaction(itemId, hex"06");
        acuityReactions.addReaction(itemId, hex"07");
        acuityReactions.addReaction(itemId, hex"08");
        acuityReactions.addReaction(itemId, hex"09");
    }

    function testGetReactions() public {
        bytes32 itemId = acuityItemStore.create(bytes2(0x0000), hex"1234");
        acuityReactions.addReaction(itemId, hex"01");
        acuityReactions.addReaction(itemId, hex"01");
        acuityReactions.addReaction(itemId, hex"01");
        bytes32 reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0100000000000000000000000000000000000000000000000000000000000000");

        acuityReactions.addReaction(itemId, hex"02");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0100000002000000000000000000000000000000000000000000000000000000");

        acuityReactions.addReaction(itemId, hex"03");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0100000002000000030000000000000000000000000000000000000000000000");

        acuityReactions.removeReaction(itemId, hex"01");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0000000002000000030000000000000000000000000000000000000000000000");

        acuityReactions.addReaction(itemId, hex"04");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0400000002000000030000000000000000000000000000000000000000000000");

        acuityReactions.addReaction(itemId, hex"05");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0400000002000000030000000500000000000000000000000000000000000000");

        acuityReactions.addReaction(itemId, hex"06");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0400000002000000030000000500000006000000000000000000000000000000");

        acuityReactions.addReaction(itemId, hex"07");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0400000002000000030000000500000006000000070000000000000000000000");

        acuityReactions.addReaction(itemId, hex"08");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0400000002000000030000000500000006000000070000000800000000000000");

        acuityReactions.addReaction(itemId, hex"09");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0400000002000000030000000500000006000000070000000800000009000000");

        acuityReactions.removeReaction(itemId, hex"06");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0400000002000000030000000500000000000000070000000800000009000000");

        acuityReactions.removeReaction(itemId, hex"07");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0400000002000000030000000500000000000000000000000800000009000000");

        acuityReactions.addReaction(itemId, hex"0a");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"040000000200000003000000050000000a000000000000000800000009000000");

        acuityReactions.addReaction(itemId, hex"0b");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"040000000200000003000000050000000a0000000b0000000800000009000000");

        acuityReactions.addReaction(itemId, hex"0a");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"040000000200000003000000050000000a0000000b0000000800000009000000");

        acuityReactions.addReaction(itemId, hex"0b");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"040000000200000003000000050000000a0000000b0000000800000009000000");

        acuityReactions.removeReaction(itemId, hex"04");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"000000000200000003000000050000000a0000000b0000000800000009000000");

        acuityReactions.removeReaction(itemId, hex"09");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"000000000200000003000000050000000a0000000b0000000800000000000000");

        acuityReactions.removeReaction(itemId, hex"02");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"000000000000000003000000050000000a0000000b0000000800000000000000");

        acuityReactions.removeReaction(itemId, hex"08");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"000000000000000003000000050000000a0000000b0000000000000000000000");

        acuityReactions.removeReaction(itemId, hex"03");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"000000000000000000000000050000000a0000000b0000000000000000000000");

        acuityReactions.removeReaction(itemId, hex"0b");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"000000000000000000000000050000000a000000000000000000000000000000");

        acuityReactions.removeReaction(itemId, hex"05");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"000000000000000000000000000000000a000000000000000000000000000000");

        acuityReactions.removeReaction(itemId, hex"0a");
        reactions = acuityReactions.getReactions(itemId);
        assertEq(reactions, hex"0000000000000000000000000000000000000000000000000000000000000000");
    }

    function testGetTrustedReactions() public {
        bytes32 itemId = acuityItemStore.create(bytes2(0x0000), hex"1234");
        AcuityReactionsProxy account0 = new AcuityReactionsProxy(acuityReactions);
        AcuityReactionsProxy account1 = new AcuityReactionsProxy(acuityReactions);
        AcuityReactionsProxy account2 = new AcuityReactionsProxy(acuityReactions);
        AcuityReactionsProxy account3 = new AcuityReactionsProxy(acuityReactions);
        AcuityReactionsProxy account4 = new AcuityReactionsProxy(acuityReactions);
        AcuityReactionsProxy account5 = new AcuityReactionsProxy(acuityReactions);
        AcuityReactionsProxy account6 = new AcuityReactionsProxy(acuityReactions);
        AcuityReactionsProxy account7 = new AcuityReactionsProxy(acuityReactions);
        AcuityReactionsProxy account8 = new AcuityReactionsProxy(acuityReactions);
        AcuityReactionsProxy account9 = new AcuityReactionsProxy(acuityReactions);

        address[] memory itemReactionAccounts;
        bytes32[] memory itemReactions;

        (itemReactionAccounts, itemReactions) = acuityReactions.getTrustedReactions(itemId);
        assertEq(itemReactionAccounts.length, 0);
        assertEq(itemReactions.length, 0);

        acuityTrustedAccounts.trustAccount(address(account0));
        acuityTrustedAccounts.trustAccount(address(account1));
        acuityTrustedAccounts.trustAccount(address(account2));
        acuityTrustedAccounts.trustAccount(address(account3));
        acuityTrustedAccounts.trustAccount(address(account4));
        acuityTrustedAccounts.trustAccount(address(account5));
        acuityTrustedAccounts.trustAccount(address(account6));
        acuityTrustedAccounts.trustAccount(address(account7));
        acuityTrustedAccounts.trustAccount(address(account8));
        acuityTrustedAccounts.trustAccount(address(account9));

        (itemReactionAccounts, itemReactions) = acuityReactions.getTrustedReactions(itemId);
        assertEq(itemReactionAccounts.length, 0);
        assertEq(itemReactions.length, 0);

        account0.addReaction(itemId, hex"01");
        (itemReactionAccounts, itemReactions) = acuityReactions.getTrustedReactions(itemId);
        assertEq(itemReactionAccounts.length, 1);
        assertEq(itemReactions.length, 1);
        assertEq(itemReactionAccounts[0], address(account0));
        assertEq(itemReactions[0], hex"01");

        account6.addReaction(itemId, hex"02");
        (itemReactionAccounts, itemReactions) = acuityReactions.getTrustedReactions(itemId);
        assertEq(itemReactionAccounts.length, 2);
        assertEq(itemReactions.length, 2);
        assertEq(itemReactionAccounts[0], address(account0));
        assertEq(itemReactions[0], hex"01");
        assertEq(itemReactionAccounts[1], address(account6));
        assertEq(itemReactions[1], hex"02");

        account9.addReaction(itemId, hex"03");
        (itemReactionAccounts, itemReactions) = acuityReactions.getTrustedReactions(itemId);
        assertEq(itemReactionAccounts.length, 3);
        assertEq(itemReactions.length, 3);
        assertEq(itemReactionAccounts[0], address(account0));
        assertEq(itemReactions[0], hex"01");
        assertEq(itemReactionAccounts[1], address(account6));
        assertEq(itemReactions[1], hex"02");
        assertEq(itemReactionAccounts[2], address(account9));
        assertEq(itemReactions[2], hex"03");

        account8.addReaction(itemId, hex"04");
        (itemReactionAccounts, itemReactions) = acuityReactions.getTrustedReactions(itemId);
        assertEq(itemReactionAccounts.length, 4);
        assertEq(itemReactions.length, 4);
        assertEq(itemReactionAccounts[0], address(account0));
        assertEq(itemReactions[0], hex"01");
        assertEq(itemReactionAccounts[1], address(account6));
        assertEq(itemReactions[1], hex"02");
        assertEq(itemReactionAccounts[2], address(account8));
        assertEq(itemReactions[2], hex"04");
        assertEq(itemReactionAccounts[3], address(account9));
        assertEq(itemReactions[3], hex"03");

        account8.addReaction(itemId, hex"05");
        (itemReactionAccounts, itemReactions) = acuityReactions.getTrustedReactions(itemId);
        assertEq(itemReactionAccounts.length, 4);
        assertEq(itemReactions.length, 4);
        assertEq(itemReactionAccounts[0], address(account0));
        assertEq(itemReactions[0], hex"01");
        assertEq(itemReactionAccounts[1], address(account6));
        assertEq(itemReactions[1], hex"02");
        assertEq(itemReactionAccounts[2], address(account8));
        assertEq(itemReactions[2], hex"0400000005");
        assertEq(itemReactionAccounts[3], address(account9));
        assertEq(itemReactions[3], hex"03");

        account7.addReaction(itemId, hex"06");
        (itemReactionAccounts, itemReactions) = acuityReactions.getTrustedReactions(itemId);
        assertEq(itemReactionAccounts.length, 5);
        assertEq(itemReactions.length, 5);
        assertEq(itemReactionAccounts[0], address(account0));
        assertEq(itemReactions[0], hex"01");
        assertEq(itemReactionAccounts[1], address(account6));
        assertEq(itemReactions[1], hex"02");
        assertEq(itemReactionAccounts[2], address(account7));
        assertEq(itemReactions[2], hex"06");
        assertEq(itemReactionAccounts[3], address(account8));
        assertEq(itemReactions[3], hex"0400000005");
        assertEq(itemReactionAccounts[4], address(account9));
        assertEq(itemReactions[4], hex"03");

        account5.addReaction(itemId, hex"07");
        (itemReactionAccounts, itemReactions) = acuityReactions.getTrustedReactions(itemId);
        assertEq(itemReactionAccounts.length, 6);
        assertEq(itemReactions.length, 6);
        assertEq(itemReactionAccounts[0], address(account0));
        assertEq(itemReactions[0], hex"01");
        assertEq(itemReactionAccounts[1], address(account5));
        assertEq(itemReactions[1], hex"07");
        assertEq(itemReactionAccounts[2], address(account6));
        assertEq(itemReactions[2], hex"02");
        assertEq(itemReactionAccounts[3], address(account7));
        assertEq(itemReactions[3], hex"06");
        assertEq(itemReactionAccounts[4], address(account8));
        assertEq(itemReactions[4], hex"0400000005");
        assertEq(itemReactionAccounts[5], address(account9));
        assertEq(itemReactions[5], hex"03");

        account1.addReaction(itemId, hex"08");
        account2.addReaction(itemId, hex"09");
        account3.addReaction(itemId, hex"0a");
        account4.addReaction(itemId, hex"0b");
        (itemReactionAccounts, itemReactions) = acuityReactions.getTrustedReactions(itemId);
        assertEq(itemReactionAccounts.length, 10);
        assertEq(itemReactions.length, 10);
        assertEq(itemReactionAccounts[0], address(account0));
        assertEq(itemReactions[0], hex"01");
        assertEq(itemReactionAccounts[1], address(account1));
        assertEq(itemReactions[1], hex"08");
        assertEq(itemReactionAccounts[2], address(account2));
        assertEq(itemReactions[2], hex"09");
        assertEq(itemReactionAccounts[3], address(account3));
        assertEq(itemReactions[3], hex"0a");
        assertEq(itemReactionAccounts[4], address(account4));
        assertEq(itemReactions[4], hex"0b");
        assertEq(itemReactionAccounts[5], address(account5));
        assertEq(itemReactions[5], hex"07");
        assertEq(itemReactionAccounts[6], address(account6));
        assertEq(itemReactions[6], hex"02");
        assertEq(itemReactionAccounts[7], address(account7));
        assertEq(itemReactions[7], hex"06");
        assertEq(itemReactionAccounts[8], address(account8));
        assertEq(itemReactions[8], hex"0400000005");
        assertEq(itemReactionAccounts[9], address(account9));
        assertEq(itemReactions[9], hex"03");

        acuityTrustedAccounts.untrustAccount(address(account3));
        acuityTrustedAccounts.untrustAccount(address(account5));
        acuityTrustedAccounts.untrustAccount(address(account9));
        (itemReactionAccounts, itemReactions) = acuityReactions.getTrustedReactions(itemId);
        assertEq(itemReactionAccounts.length, 7);
        assertEq(itemReactions.length, 7);
        assertEq(itemReactionAccounts[0], address(account0));
        assertEq(itemReactions[0], hex"01");
        assertEq(itemReactionAccounts[1], address(account1));
        assertEq(itemReactions[1], hex"08");
        assertEq(itemReactionAccounts[2], address(account2));
        assertEq(itemReactions[2], hex"09");
        assertEq(itemReactionAccounts[3], address(account7));
        assertEq(itemReactions[3], hex"06");
        assertEq(itemReactionAccounts[4], address(account4));
        assertEq(itemReactions[4], hex"0b");
        assertEq(itemReactionAccounts[5], address(account8));
        assertEq(itemReactions[5], hex"0400000005");
        assertEq(itemReactionAccounts[6], address(account6));
        assertEq(itemReactions[6], hex"02");
    }

}
