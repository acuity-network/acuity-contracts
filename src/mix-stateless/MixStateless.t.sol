pragma solidity ^0.6.6;

import "ds-test/test.sol";
import "../mix-item-store/MixItemStoreRegistry.sol";
import "../mix-item-store/MixItemStoreIpfsSha256.sol";
import "../mix-item-dag/MixItemDagOnlyOwner.sol";

import "./MixStateless.sol";

contract MixStatelessTest is DSTest {
    MixStateless stateless;
    MixItemStoreRegistry mixItemStoreRegistry;
    MixItemStoreIpfsSha256 mixItemStore;
    MixItemDagOnlyOwner mixItemDagOnlyOwner;

    function setUp() public {
        mixItemStoreRegistry = new MixItemStoreRegistry();
        mixItemStore = new MixItemStoreIpfsSha256(mixItemStoreRegistry);
        mixItemDagOnlyOwner = new MixItemDagOnlyOwner(mixItemStoreRegistry);
        stateless = new MixStateless(mixItemStore, mixItemDagOnlyOwner);
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
