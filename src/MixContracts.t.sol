pragma solidity ^0.5.15;

import "ds-test/test.sol";

import "./MixContracts.sol";

contract MixContractsTest is DSTest {
    MixContracts contracts;

    function setUp() public {
        contracts = new MixContracts();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
