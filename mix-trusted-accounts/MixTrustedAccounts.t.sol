pragma solidity ^0.5.10;

import "ds-test/test.sol";

import "./MixTrustedAccounts.sol";
import "./MixTrustedAccountsProxy.sol";


contract MixTrustedAccountsTest is DSTest {

    MixTrustedAccounts mixTrustedAccounts;
    MixTrustedAccountsProxy mixTrustedAccountsProxy;
    MixTrustedAccountsProxy mixTrustedAccountsProxy2;

    function setUp() public {
        mixTrustedAccounts = new MixTrustedAccounts();
        mixTrustedAccountsProxy = new MixTrustedAccountsProxy(mixTrustedAccounts);
        mixTrustedAccountsProxy2 = new MixTrustedAccountsProxy(mixTrustedAccounts);
    }

    function testControlCantTrustSelf() public {
        mixTrustedAccounts.trustAccount(address(0x1234));
    }

    function testFailCantTrustSelf() public {
        mixTrustedAccounts.trustAccount(address(this));
    }

    function testControlCantTrustTrusted() public {
        mixTrustedAccounts.trustAccount(address(0x1234));
        mixTrustedAccounts.trustAccount(address(0x2345));
    }

    function testFailCantTrustTrusted() public {
        mixTrustedAccounts.trustAccount(address(0x1234));
        mixTrustedAccounts.trustAccount(address(0x1234));
    }

    function testTrustAccount() public {
        mixTrustedAccounts.trustAccount(address(0x1234));
        assertEq(mixTrustedAccounts.getTrustedCount(), 1);
        assertTrue(mixTrustedAccounts.getIsTrusted(address(0x1234)));
        mixTrustedAccounts.trustAccount(address(0x2345));
        assertEq(mixTrustedAccounts.getTrustedCount(), 2);
        assertTrue(mixTrustedAccounts.getIsTrusted(address(0x2345)));
        mixTrustedAccounts.trustAccount(address(0x4567));
        assertEq(mixTrustedAccounts.getTrustedCount(), 3);
        assertTrue(mixTrustedAccounts.getIsTrusted(address(0x4567)));
        mixTrustedAccounts.trustAccount(address(0x5678));
        assertEq(mixTrustedAccounts.getTrustedCount(), 4);
        assertTrue(mixTrustedAccounts.getIsTrusted(address(0x5678)));
    }

    function testControlCantUntrustUntrusted() public {
        mixTrustedAccounts.trustAccount(address(0x1234));
        mixTrustedAccounts.untrustAccount(address(0x1234));
    }

    function testFailCantUntrustUntrusted() public {
        mixTrustedAccounts.untrustAccount(address(0x1234));
    }

    function testUntrustAccount() public {
        mixTrustedAccounts.trustAccount(address(0x1234));
        mixTrustedAccounts.trustAccount(address(0x2345));
        mixTrustedAccounts.trustAccount(address(0x4567));
        mixTrustedAccounts.trustAccount(address(0x5678));

        mixTrustedAccounts.untrustAccount(address(0x2345));
        assertEq(mixTrustedAccounts.getTrustedCount(), 3);
        assertTrue(mixTrustedAccounts.getIsTrusted(address(0x1234)));
        assertTrue(!mixTrustedAccounts.getIsTrusted(address(0x2345)));
        assertTrue(mixTrustedAccounts.getIsTrusted(address(0x4567)));
        assertTrue(mixTrustedAccounts.getIsTrusted(address(0x5678)));

        mixTrustedAccounts.untrustAccount(address(0x5678));
        assertEq(mixTrustedAccounts.getTrustedCount(), 2);
        assertTrue(mixTrustedAccounts.getIsTrusted(address(0x1234)));
        assertTrue(!mixTrustedAccounts.getIsTrusted(address(0x2345)));
        assertTrue(mixTrustedAccounts.getIsTrusted(address(0x4567)));
        assertTrue(!mixTrustedAccounts.getIsTrusted(address(0x5678)));

        mixTrustedAccounts.untrustAccount(address(0x1234));
        assertEq(mixTrustedAccounts.getTrustedCount(), 1);
        assertTrue(!mixTrustedAccounts.getIsTrusted(address(0x1234)));
        assertTrue(!mixTrustedAccounts.getIsTrusted(address(0x2345)));
        assertTrue(mixTrustedAccounts.getIsTrusted(address(0x4567)));
        assertTrue(!mixTrustedAccounts.getIsTrusted(address(0x5678)));

        mixTrustedAccounts.untrustAccount(address(0x4567));
        assertEq(mixTrustedAccounts.getTrustedCount(), 0);
        assertTrue(!mixTrustedAccounts.getIsTrusted(address(0x1234)));
        assertTrue(!mixTrustedAccounts.getIsTrusted(address(0x2345)));
        assertTrue(!mixTrustedAccounts.getIsTrusted(address(0x4567)));
        assertTrue(!mixTrustedAccounts.getIsTrusted(address(0x5678)));
    }

    function testGetIsTrustedByAccount() public {
        mixTrustedAccountsProxy.trustAccount(address(0x1234));
        assertTrue(!mixTrustedAccounts.getIsTrustedByAccount(msg.sender, address(0x1234)));
        assertTrue(mixTrustedAccounts.getIsTrustedByAccount(address(mixTrustedAccountsProxy), address(0x1234)));
    }

    function testGetIsTrustedDeep() public {
        mixTrustedAccounts.trustAccount(address(0x1234));
        mixTrustedAccounts.trustAccount(address(0x2345));
        mixTrustedAccountsProxy.trustAccount(address(0x3456));
        mixTrustedAccountsProxy.trustAccount(address(0x4567));
        assertTrue(mixTrustedAccounts.getIsTrustedDeep(address(0x1234)));
        assertTrue(mixTrustedAccounts.getIsTrustedDeep(address(0x2345)));
        assertTrue(!mixTrustedAccounts.getIsTrustedDeep(address(0x3456)));
        assertTrue(!mixTrustedAccounts.getIsTrustedDeep(address(0x4567)));

        mixTrustedAccounts.trustAccount(address(mixTrustedAccountsProxy));
        assertTrue(mixTrustedAccounts.getIsTrustedDeep(address(0x1234)));
        assertTrue(mixTrustedAccounts.getIsTrustedDeep(address(0x2345)));
        assertTrue(mixTrustedAccounts.getIsTrustedDeep(address(0x3456)));
        assertTrue(mixTrustedAccounts.getIsTrustedDeep(address(0x4567)));

        mixTrustedAccounts.untrustAccount(address(mixTrustedAccountsProxy));
        assertTrue(mixTrustedAccounts.getIsTrustedDeep(address(0x1234)));
        assertTrue(mixTrustedAccounts.getIsTrustedDeep(address(0x2345)));
        assertTrue(!mixTrustedAccounts.getIsTrustedDeep(address(0x3456)));
        assertTrue(!mixTrustedAccounts.getIsTrustedDeep(address(0x4567)));
    }

    function testGetIsTrustedDeepByAccount() public {
        mixTrustedAccountsProxy2.trustAccount(address(0x1234));
        mixTrustedAccountsProxy2.trustAccount(address(0x2345));
        mixTrustedAccountsProxy.trustAccount(address(0x3456));
        mixTrustedAccountsProxy.trustAccount(address(0x4567));
        assertTrue(mixTrustedAccounts.getIsTrustedDeepByAccount(address(mixTrustedAccountsProxy2), address(0x1234)));
        assertTrue(mixTrustedAccounts.getIsTrustedDeepByAccount(address(mixTrustedAccountsProxy2), address(0x2345)));
        assertTrue(!mixTrustedAccounts.getIsTrustedDeepByAccount(address(mixTrustedAccountsProxy2), address(0x3456)));
        assertTrue(!mixTrustedAccounts.getIsTrustedDeepByAccount(address(mixTrustedAccountsProxy2), address(0x4567)));

        mixTrustedAccountsProxy2.trustAccount(address(mixTrustedAccountsProxy));
        assertTrue(mixTrustedAccounts.getIsTrustedDeepByAccount(address(mixTrustedAccountsProxy2), address(0x1234)));
        assertTrue(mixTrustedAccounts.getIsTrustedDeepByAccount(address(mixTrustedAccountsProxy2), address(0x2345)));
        assertTrue(mixTrustedAccounts.getIsTrustedDeepByAccount(address(mixTrustedAccountsProxy2), address(0x3456)));
        assertTrue(mixTrustedAccounts.getIsTrustedDeepByAccount(address(mixTrustedAccountsProxy2), address(0x4567)));

        mixTrustedAccountsProxy2.untrustAccount(address(mixTrustedAccountsProxy));
        assertTrue(mixTrustedAccounts.getIsTrustedDeepByAccount(address(mixTrustedAccountsProxy2), address(0x1234)));
        assertTrue(mixTrustedAccounts.getIsTrustedDeepByAccount(address(mixTrustedAccountsProxy2), address(0x2345)));
        assertTrue(!mixTrustedAccounts.getIsTrustedDeepByAccount(address(mixTrustedAccountsProxy2), address(0x3456)));
        assertTrue(!mixTrustedAccounts.getIsTrustedDeepByAccount(address(mixTrustedAccountsProxy2), address(0x4567)));
    }

    function testGetIsTrustedOnlyDeep() public {
        mixTrustedAccounts.trustAccount(address(0x1234));
        mixTrustedAccounts.trustAccount(address(0x2345));
        mixTrustedAccountsProxy.trustAccount(address(0x3456));
        mixTrustedAccountsProxy.trustAccount(address(0x4567));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeep(address(0x1234)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeep(address(0x2345)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeep(address(0x3456)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeep(address(0x4567)));

        mixTrustedAccounts.trustAccount(address(mixTrustedAccountsProxy));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeep(address(0x1234)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeep(address(0x2345)));
        assertTrue(mixTrustedAccounts.getIsTrustedOnlyDeep(address(0x3456)));
        assertTrue(mixTrustedAccounts.getIsTrustedOnlyDeep(address(0x4567)));

        mixTrustedAccounts.untrustAccount(address(mixTrustedAccountsProxy));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeep(address(0x1234)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeep(address(0x2345)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeep(address(0x3456)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeep(address(0x4567)));
    }

    function testGetIsTrustedOnlyDeepByAccount() public {
        mixTrustedAccountsProxy2.trustAccount(address(0x1234));
        mixTrustedAccountsProxy2.trustAccount(address(0x2345));
        mixTrustedAccountsProxy.trustAccount(address(0x3456));
        mixTrustedAccountsProxy.trustAccount(address(0x4567));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(mixTrustedAccountsProxy2), address(0x1234)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(mixTrustedAccountsProxy2), address(0x2345)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(mixTrustedAccountsProxy2), address(0x3456)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(mixTrustedAccountsProxy2), address(0x4567)));

        mixTrustedAccountsProxy2.trustAccount(address(mixTrustedAccountsProxy));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(mixTrustedAccountsProxy2), address(0x1234)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(mixTrustedAccountsProxy2), address(0x2345)));
        assertTrue(mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(mixTrustedAccountsProxy2), address(0x3456)));
        assertTrue(mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(mixTrustedAccountsProxy2), address(0x4567)));

        mixTrustedAccountsProxy2.untrustAccount(address(mixTrustedAccountsProxy));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(mixTrustedAccountsProxy2), address(0x1234)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(mixTrustedAccountsProxy2), address(0x2345)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(mixTrustedAccountsProxy2), address(0x3456)));
        assertTrue(!mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(address(mixTrustedAccountsProxy2), address(0x4567)));
    }

    function testGetTrustedThatTrustAccountByAccount() public {
        mixTrustedAccountsProxy.trustAccount(address(0x1234));
        mixTrustedAccountsProxy.trustAccount(address(0x2345));
        mixTrustedAccountsProxy.trustAccount(address(0x3456));
        mixTrustedAccountsProxy2.trustAccount(address(0x3456));
        mixTrustedAccountsProxy2.trustAccount(address(0x4567));
        mixTrustedAccountsProxy2.trustAccount(address(0x5678));
        mixTrustedAccountsProxy2.trustAccount(address(0x789a));

        address[] memory accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x1234));
        assertEq(accounts.length, 0);
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x1234));
        assertEq(accounts.length, 0);
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x3456));
        assertEq(accounts.length, 0);
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x5678));
        assertEq(accounts.length, 0);
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x789a));
        assertEq(accounts.length, 0);

        mixTrustedAccounts.trustAccount(address(mixTrustedAccountsProxy));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x3456));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x5678));
        assertEq(accounts.length, 0);
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x789a));
        assertEq(accounts.length, 0);

        mixTrustedAccounts.trustAccount(address(mixTrustedAccountsProxy2));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x3456));
        assertEq(accounts.length, 2);
        assertEq(accounts[0], address(mixTrustedAccountsProxy));
        assertEq(accounts[1], address(mixTrustedAccountsProxy2));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x5678));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy2));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccountByAccount(address(this), address(0x789a));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy2));
    }

    function testGetTrustedThatTrustAccount() public {
        mixTrustedAccountsProxy.trustAccount(address(0x1234));
        mixTrustedAccountsProxy.trustAccount(address(0x2345));
        mixTrustedAccountsProxy.trustAccount(address(0x3456));
        mixTrustedAccountsProxy2.trustAccount(address(0x3456));
        mixTrustedAccountsProxy2.trustAccount(address(0x4567));
        mixTrustedAccountsProxy2.trustAccount(address(0x5678));
        mixTrustedAccountsProxy2.trustAccount(address(0x789a));

        address[] memory accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x1234));
        assertEq(accounts.length, 0);
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x1234));
        assertEq(accounts.length, 0);
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x3456));
        assertEq(accounts.length, 0);
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x5678));
        assertEq(accounts.length, 0);
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x789a));
        assertEq(accounts.length, 0);

        mixTrustedAccounts.trustAccount(address(mixTrustedAccountsProxy));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x3456));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x5678));
        assertEq(accounts.length, 0);
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x789a));
        assertEq(accounts.length, 0);

        mixTrustedAccounts.trustAccount(address(mixTrustedAccountsProxy2));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x1234));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x3456));
        assertEq(accounts.length, 2);
        assertEq(accounts[0], address(mixTrustedAccountsProxy));
        assertEq(accounts[1], address(mixTrustedAccountsProxy2));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x5678));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy2));
        accounts = mixTrustedAccounts.getTrustedThatTrustAccount(address(0x789a));
        assertEq(accounts.length, 1);
        assertEq(accounts[0], address(mixTrustedAccountsProxy2));
    }

}
