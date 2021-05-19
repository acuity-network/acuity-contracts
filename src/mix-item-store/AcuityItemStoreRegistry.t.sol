pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./AcuityItemStoreRegistry.sol";
import "./AcuityItemStoreIpfsSha256.sol";


contract AcuityItemStoreRegistryTest is DSTest {

    AcuityItemStoreRegistry mixItemStoreRegistry;
    AcuityItemStoreIpfsSha256 mixItemStoreIpfsSha256;

    function setUp() public {
        mixItemStoreRegistry = new AcuityItemStoreRegistry();
        mixItemStoreIpfsSha256 = new AcuityItemStoreIpfsSha256(mixItemStoreRegistry);
    }

    function testControlRegisterContractIdAgain() public {
        mixItemStoreRegistry.register();
    }

    function testFailRegisterContractIdAgain() public {
        mixItemStoreRegistry.register();
        mixItemStoreRegistry.register();
    }

    function testControlAcuityItemStoreNotRegistered() public view {
        mixItemStoreRegistry.getItemStore(bytes32(mixItemStoreIpfsSha256.getContractId()) >> 192);
    }

    function testFailAcuityItemStoreNotRegistered() public view {
        mixItemStoreRegistry.getItemStore(0);
    }

    function testGetItemStore() public {
        assertEq(address(mixItemStoreRegistry.getItemStore(bytes32(mixItemStoreIpfsSha256.getContractId()) >> 192)), address(mixItemStoreIpfsSha256));
    }

}
