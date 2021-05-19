// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;

import "ds-test/test.sol";

import "./AcuityItemStoreRegistry.sol";
import "./AcuityItemStoreIpfsSha256.sol";


contract AcuityItemStoreRegistryTest is DSTest {

    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStoreIpfsSha256;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStoreIpfsSha256 = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
    }

    function testControlRegisterContractIdAgain() public {
        acuityItemStoreRegistry.register();
    }

    function testFailRegisterContractIdAgain() public {
        acuityItemStoreRegistry.register();
        acuityItemStoreRegistry.register();
    }

    function testControlAcuityItemStoreNotRegistered() public view {
        acuityItemStoreRegistry.getItemStore(bytes32(acuityItemStoreIpfsSha256.getContractId()) >> 192);
    }

    function testFailAcuityItemStoreNotRegistered() public view {
        acuityItemStoreRegistry.getItemStore(0);
    }

    function testGetItemStore() public {
        assertEq(address(acuityItemStoreRegistry.getItemStore(bytes32(acuityItemStoreIpfsSha256.getContractId()) >> 192)), address(acuityItemStoreIpfsSha256));
    }

}
