// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "ds-test/test.sol";

import "./AcuityTrustedAccounts.sol";
import "./AcuityTrustedAccountsProxy.sol";


contract AcuityTrustedAccountsTest is DSTest {

    AcuityTrustedAccounts acuityTrustedAccounts;
    AcuityTrustedAccountsProxy acuityTrustedAccountsProxy;
    AcuityTrustedAccountsProxy acuityTrustedAccountsProxy2;

    function setUp() public {
        acuityTrustedAccounts = new AcuityTrustedAccounts();
        acuityTrustedAccountsProxy = new AcuityTrustedAccountsProxy(acuityTrustedAccounts);
        acuityTrustedAccountsProxy2 = new AcuityTrustedAccountsProxy(acuityTrustedAccounts);
    }

    function testControlCantTrustSelf() public {
        acuityTrustedAccounts.trustAccount(address(0x1234));
    }

    function testFailCantTrustSelf() public {
        acuityTrustedAccounts.trustAccount(address(this));
    }

    function testControlCantTrustTrusted() public {
        acuityTrustedAccounts.trustAccount(address(0x1234));
        acuityTrustedAccounts.trustAccount(address(0x2345));
    }

    function testFailCantTrustTrusted() public {
        acuityTrustedAccounts.trustAccount(address(0x1234));
        acuityTrustedAccounts.trustAccount(address(0x1234));
    }

    function testTrustAccount() public {
        acuityTrustedAccounts.trustAccount(address(0x1234));
        assertEq(acuityTrustedAccounts.getTrustedCount(), 1);
        assertTrue(acuityTrustedAccounts.getIsTrusted(address(0x1234)));
        acuityTrustedAccounts.trustAccount(address(0x2345));
        assertEq(acuityTrustedAccounts.getTrustedCount(), 2);
        assertTrue(acuityTrustedAccounts.getIsTrusted(address(0x2345)));
        acuityTrustedAccounts.trustAccount(address(0x4567));
        assertEq(acuityTrustedAccounts.getTrustedCount(), 3);
        assertTrue(acuityTrustedAccounts.getIsTrusted(address(0x4567)));
        acuityTrustedAccounts.trustAccount(address(0x5678));
        assertEq(acuityTrustedAccounts.getTrustedCount(), 4);
        assertTrue(acuityTrustedAccounts.getIsTrusted(address(0x5678)));
    }

    function testControlCantUntrustUntrusted() public {
        acuityTrustedAccounts.trustAccount(address(0x1234));
        acuityTrustedAccounts.untrustAccount(address(0x1234));
    }

    function testFailCantUntrustUntrusted() public {
        acuityTrustedAccounts.untrustAccount(address(0x1234));
    }

    function testUntrustAccount() public {
        acuityTrustedAccounts.trustAccount(address(0x1234));
        acuityTrustedAccounts.trustAccount(address(0x2345));
        acuityTrustedAccounts.trustAccount(address(0x4567));
        acuityTrustedAccounts.trustAccount(address(0x5678));

        acuityTrustedAccounts.untrustAccount(address(0x2345));
        assertEq(acuityTrustedAccounts.getTrustedCount(), 3);
        assertTrue(acuityTrustedAccounts.getIsTrusted(address(0x1234)));
        assertTrue(!acuityTrustedAccounts.getIsTrusted(address(0x2345)));
        assertTrue(acuityTrustedAccounts.getIsTrusted(address(0x4567)));
        assertTrue(acuityTrustedAccounts.getIsTrusted(address(0x5678)));

        acuityTrustedAccounts.untrustAccount(address(0x5678));
        assertEq(acuityTrustedAccounts.getTrustedCount(), 2);
        assertTrue(acuityTrustedAccounts.getIsTrusted(address(0x1234)));
        assertTrue(!acuityTrustedAccounts.getIsTrusted(address(0x2345)));
        assertTrue(acuityTrustedAccounts.getIsTrusted(address(0x4567)));
        assertTrue(!acuityTrustedAccounts.getIsTrusted(address(0x5678)));

        acuityTrustedAccounts.untrustAccount(address(0x1234));
        assertEq(acuityTrustedAccounts.getTrustedCount(), 1);
        assertTrue(!acuityTrustedAccounts.getIsTrusted(address(0x1234)));
        assertTrue(!acuityTrustedAccounts.getIsTrusted(address(0x2345)));
        assertTrue(acuityTrustedAccounts.getIsTrusted(address(0x4567)));
        assertTrue(!acuityTrustedAccounts.getIsTrusted(address(0x5678)));

        acuityTrustedAccounts.untrustAccount(address(0x4567));
        assertEq(acuityTrustedAccounts.getTrustedCount(), 0);
        assertTrue(!acuityTrustedAccounts.getIsTrusted(address(0x1234)));
        assertTrue(!acuityTrustedAccounts.getIsTrusted(address(0x2345)));
        assertTrue(!acuityTrustedAccounts.getIsTrusted(address(0x4567)));
        assertTrue(!acuityTrustedAccounts.getIsTrusted(address(0x5678)));
    }

    function testGetIsTrustedByAccount() public {
        acuityTrustedAccountsProxy.trustAccount(address(0x1234));
        assertTrue(!acuityTrustedAccounts.getIsTrustedByAccount(msg.sender, address(0x1234)));
        assertTrue(acuityTrustedAccounts.getIsTrustedByAccount(address(acuityTrustedAccountsProxy), address(0x1234)));
    }

    function testGetIsTrustedDeep() public {
        acuityTrustedAccounts.trustAccount(address(0x1234));
        acuityTrustedAccounts.trustAccount(address(0x2345));
        acuityTrustedAccountsProxy.trustAccount(address(0x3456));
        acuityTrustedAccountsProxy.trustAccount(address(0x4567));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeep(address(0x1234)));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeep(address(0x2345)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedDeep(address(0x3456)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedDeep(address(0x4567)));

        acuityTrustedAccounts.trustAccount(address(acuityTrustedAccountsProxy));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeep(address(0x1234)));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeep(address(0x2345)));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeep(address(0x3456)));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeep(address(0x4567)));

        acuityTrustedAccounts.untrustAccount(address(acuityTrustedAccountsProxy));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeep(address(0x1234)));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeep(address(0x2345)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedDeep(address(0x3456)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedDeep(address(0x4567)));
    }

    function testGetIsTrustedDeepByAccount() public {
        acuityTrustedAccountsProxy2.trustAccount(address(0x1234));
        acuityTrustedAccountsProxy2.trustAccount(address(0x2345));
        acuityTrustedAccountsProxy.trustAccount(address(0x3456));
        acuityTrustedAccountsProxy.trustAccount(address(0x4567));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x1234)));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x2345)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x3456)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x4567)));

        acuityTrustedAccountsProxy2.trustAccount(address(acuityTrustedAccountsProxy));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x1234)));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x2345)));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x3456)));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x4567)));

        acuityTrustedAccountsProxy2.untrustAccount(address(acuityTrustedAccountsProxy));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x1234)));
        assertTrue(acuityTrustedAccounts.getIsTrustedDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x2345)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x3456)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x4567)));
    }

    function testGetIsTrustedOnlyDeep() public {
        acuityTrustedAccounts.trustAccount(address(0x1234));
        acuityTrustedAccounts.trustAccount(address(0x2345));
        acuityTrustedAccountsProxy.trustAccount(address(0x3456));
        acuityTrustedAccountsProxy.trustAccount(address(0x4567));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeep(address(0x1234)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeep(address(0x2345)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeep(address(0x3456)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeep(address(0x4567)));

        acuityTrustedAccounts.trustAccount(address(acuityTrustedAccountsProxy));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeep(address(0x1234)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeep(address(0x2345)));
        assertTrue(acuityTrustedAccounts.getIsTrustedOnlyDeep(address(0x3456)));
        assertTrue(acuityTrustedAccounts.getIsTrustedOnlyDeep(address(0x4567)));

        acuityTrustedAccounts.untrustAccount(address(acuityTrustedAccountsProxy));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeep(address(0x1234)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeep(address(0x2345)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeep(address(0x3456)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeep(address(0x4567)));
    }

    function testGetIsTrustedOnlyDeepByAccount() public {
        acuityTrustedAccountsProxy2.trustAccount(address(0x1234));
        acuityTrustedAccountsProxy2.trustAccount(address(0x2345));
        acuityTrustedAccountsProxy.trustAccount(address(0x3456));
        acuityTrustedAccountsProxy.trustAccount(address(0x4567));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x1234)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x2345)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x3456)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x4567)));

        acuityTrustedAccountsProxy2.trustAccount(address(acuityTrustedAccountsProxy));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x1234)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x2345)));
        assertTrue(acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x3456)));
        assertTrue(acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x4567)));

        acuityTrustedAccountsProxy2.untrustAccount(address(acuityTrustedAccountsProxy));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x1234)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x2345)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x3456)));
        assertTrue(!acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(acuityTrustedAccountsProxy2), address(0x4567)));
    }

    function testGetTrustedThatTrustAccountByAccount() public {
        acuityTrustedAccountsProxy.trustAccount(address(0x1234));
        acuityTrustedAccountsProxy.trustAccount(address(0x2345));
        acuityTrustedAccountsProxy.trustAccount(address(0x3456));
        acuityTrustedAccountsProxy2.trustAccount(address(0x3456));
        acuityTrustedAccountsProxy2.trustAccount(address(0x4567));
        acuityTrustedAccountsProxy2.trustAccount(address(0x5678));
        acuityTrustedAccountsProxy2.trustAccount(address(0x789a));

        address[] memory accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x1234));
        assertEq(accounts.length, 0);
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x1234));
        assertEq(accounts.length, 0);
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x3456));
        assertEq(accounts.length, 0);
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x5678));
        assertEq(accounts.length, 0);
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x789a));
        assertEq(accounts.length, 0);

        acuityTrustedAccounts.trustAccount(address(acuityTrustedAccountsProxy));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x3456));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x5678));
        assertEq(accounts.length, 0);
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x789a));
        assertEq(accounts.length, 0);

        acuityTrustedAccounts.trustAccount(address(acuityTrustedAccountsProxy2));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x3456));
        assertEq(accounts.length, 2);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy));
        assertEq(accounts[1], address(acuityTrustedAccountsProxy2));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x5678));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy2));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x789a));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy2));
    }

    function testGetTrustedThatTrustAccount() public {
        acuityTrustedAccountsProxy.trustAccount(address(0x1234));
        acuityTrustedAccountsProxy.trustAccount(address(0x2345));
        acuityTrustedAccountsProxy.trustAccount(address(0x3456));
        acuityTrustedAccountsProxy2.trustAccount(address(0x3456));
        acuityTrustedAccountsProxy2.trustAccount(address(0x4567));
        acuityTrustedAccountsProxy2.trustAccount(address(0x5678));
        acuityTrustedAccountsProxy2.trustAccount(address(0x789a));

        address[] memory accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x1234));
        assertEq(accounts.length, 0);
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x1234));
        assertEq(accounts.length, 0);
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x3456));
        assertEq(accounts.length, 0);
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x5678));
        assertEq(accounts.length, 0);
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x789a));
        assertEq(accounts.length, 0);

        acuityTrustedAccounts.trustAccount(address(acuityTrustedAccountsProxy));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x3456));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x5678));
        assertEq(accounts.length, 0);
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x789a));
        assertEq(accounts.length, 0);

        acuityTrustedAccounts.trustAccount(address(acuityTrustedAccountsProxy2));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x3456));
        assertEq(accounts.length, 2);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy));
        assertEq(accounts[1], address(acuityTrustedAccountsProxy2));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x5678));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy2));
        accounts = acuityTrustedAccounts.getTrustedThatTrustAccount(address(0x789a));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(acuityTrustedAccountsProxy2));
    }

}
