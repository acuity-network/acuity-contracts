// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;

import "ds-test/test.sol";

import "./AcuityAccountProfile.sol";

import "../acuity-item-store/AcuityItemStoreRegistry.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256.sol";
import "../acuity-item-store/AcuityItemStoreIpfsSha256Proxy.sol";


contract AcuityAccountProfileTest is DSTest {

    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStoreIpfsSha256;
    AcuityItemStoreIpfsSha256Proxy acuityItemStoreIpfsSha256Proxy;
    AcuityAccountProfile acuityAccountProfile;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStoreIpfsSha256 = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        acuityItemStoreIpfsSha256Proxy = new AcuityItemStoreIpfsSha256Proxy(acuityItemStoreIpfsSha256);
        acuityAccountProfile = new AcuityAccountProfile(acuityItemStoreRegistry);
    }

    function testControlSetProfileNotOwner() public {
      bytes32 itemId = acuityItemStoreIpfsSha256.create(bytes2(0x0001), hex"1234");
      acuityAccountProfile.setProfile(itemId);
    }

    function testFailSetProfileNotOwner() public {
      bytes32 itemId = acuityItemStoreIpfsSha256Proxy.create(bytes2(0x0001), hex"1234");
      acuityAccountProfile.setProfile(itemId);
    }

    function testControlGetProfileNoProfile() public {
      bytes32 itemId = acuityItemStoreIpfsSha256.create(bytes2(0x0001), hex"1234");
      acuityAccountProfile.setProfile(itemId);
      acuityAccountProfile.getProfile();
    }

    function testFailGetProfileNoProfile() public view {
      acuityAccountProfile.getProfile();
    }

    function testSetProfile() public {
      bytes32 itemId = acuityItemStoreIpfsSha256.create(bytes2(0x0001), hex"1234");
      acuityAccountProfile.setProfile(itemId);
      assertEq(acuityAccountProfile.getProfile(), itemId);

      itemId = acuityItemStoreIpfsSha256.create(bytes2(0x0002), hex"1234");
      acuityAccountProfile.setProfile(itemId);
      assertEq(acuityAccountProfile.getProfile(), itemId);

      itemId = acuityItemStoreIpfsSha256.create(bytes2(0x0003), hex"1234");
      acuityAccountProfile.setProfile(itemId);
      assertEq(acuityAccountProfile.getProfile(), itemId);

      itemId = acuityItemStoreIpfsSha256.create(bytes2(0x0004), hex"1234");
      acuityAccountProfile.setProfile(itemId);
      assertEq(acuityAccountProfile.getProfile(), itemId);
    }

    function testControlGetProfileByAccountNoProfile() public {
      bytes32 itemId = acuityItemStoreIpfsSha256.create(bytes2(0x0001), hex"1234");
      acuityAccountProfile.setProfile(itemId);
      acuityAccountProfile.getProfileByAccount(address(this));
    }

    function testFailGetProfileByAccountNoProfile() public view {
      acuityAccountProfile.getProfileByAccount(address(this));
    }

    function testSetProfileByAccount() public {
      bytes32 itemId = acuityItemStoreIpfsSha256.create(bytes2(0x0001), hex"1234");
      acuityAccountProfile.setProfile(itemId);
      assertEq(acuityAccountProfile.getProfileByAccount(address(this)), itemId);

      itemId = acuityItemStoreIpfsSha256.create(bytes2(0x0002), hex"1234");
      acuityAccountProfile.setProfile(itemId);
      assertEq(acuityAccountProfile.getProfileByAccount(address(this)), itemId);

      itemId = acuityItemStoreIpfsSha256.create(bytes2(0x0003), hex"1234");
      acuityAccountProfile.setProfile(itemId);
      assertEq(acuityAccountProfile.getProfileByAccount(address(this)), itemId);

      itemId = acuityItemStoreIpfsSha256.create(bytes2(0x0004), hex"1234");
      acuityAccountProfile.setProfile(itemId);
      assertEq(acuityAccountProfile.getProfileByAccount(address(this)), itemId);
    }

}
