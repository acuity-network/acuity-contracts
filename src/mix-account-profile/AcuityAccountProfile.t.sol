pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./AcuityAccountProfile.sol";

import "../mix-item-store/AcuityItemStoreRegistry.sol";
import "../mix-item-store/AcuityItemStoreIpfsSha256.sol";
import "../mix-item-store/AcuityItemStoreIpfsSha256Proxy.sol";


contract AcuityAccountProfileTest is DSTest {

    AcuityItemStoreRegistry mixItemStoreRegistry;
    AcuityItemStoreIpfsSha256 mixItemStoreIpfsSha256;
    AcuityItemStoreIpfsSha256Proxy mixItemStoreIpfsSha256Proxy;
    AcuityAccountProfile mixAccountProfile;

    function setUp() public {
        mixItemStoreRegistry = new AcuityItemStoreRegistry();
        mixItemStoreIpfsSha256 = new AcuityItemStoreIpfsSha256(mixItemStoreRegistry);
        mixItemStoreIpfsSha256Proxy = new AcuityItemStoreIpfsSha256Proxy(mixItemStoreIpfsSha256);
        mixAccountProfile = new AcuityAccountProfile(mixItemStoreRegistry);
    }

    function testControlSetProfileNotOwner() public {
      bytes32 itemId = mixItemStoreIpfsSha256.create(bytes2(0x0001), hex"1234");
      mixAccountProfile.setProfile(itemId);
    }

    function testFailSetProfileNotOwner() public {
      bytes32 itemId = mixItemStoreIpfsSha256Proxy.create(bytes2(0x0001), hex"1234");
      mixAccountProfile.setProfile(itemId);
    }

    function testControlGetProfileNoProfile() public {
      bytes32 itemId = mixItemStoreIpfsSha256.create(bytes2(0x0001), hex"1234");
      mixAccountProfile.setProfile(itemId);
      mixAccountProfile.getProfile();
    }

    function testFailGetProfileNoProfile() public view {
      mixAccountProfile.getProfile();
    }

    function testSetProfile() public {
      bytes32 itemId = mixItemStoreIpfsSha256.create(bytes2(0x0001), hex"1234");
      mixAccountProfile.setProfile(itemId);
      assertEq(mixAccountProfile.getProfile(), itemId);

      itemId = mixItemStoreIpfsSha256.create(bytes2(0x0002), hex"1234");
      mixAccountProfile.setProfile(itemId);
      assertEq(mixAccountProfile.getProfile(), itemId);

      itemId = mixItemStoreIpfsSha256.create(bytes2(0x0003), hex"1234");
      mixAccountProfile.setProfile(itemId);
      assertEq(mixAccountProfile.getProfile(), itemId);

      itemId = mixItemStoreIpfsSha256.create(bytes2(0x0004), hex"1234");
      mixAccountProfile.setProfile(itemId);
      assertEq(mixAccountProfile.getProfile(), itemId);
    }

    function testControlGetProfileByAccountNoProfile() public {
      bytes32 itemId = mixItemStoreIpfsSha256.create(bytes2(0x0001), hex"1234");
      mixAccountProfile.setProfile(itemId);
      mixAccountProfile.getProfileByAccount(address(this));
    }

    function testFailGetProfileByAccountNoProfile() public view {
      mixAccountProfile.getProfileByAccount(address(this));
    }

    function testSetProfileByAccount() public {
      bytes32 itemId = mixItemStoreIpfsSha256.create(bytes2(0x0001), hex"1234");
      mixAccountProfile.setProfile(itemId);
      assertEq(mixAccountProfile.getProfileByAccount(address(this)), itemId);

      itemId = mixItemStoreIpfsSha256.create(bytes2(0x0002), hex"1234");
      mixAccountProfile.setProfile(itemId);
      assertEq(mixAccountProfile.getProfileByAccount(address(this)), itemId);

      itemId = mixItemStoreIpfsSha256.create(bytes2(0x0003), hex"1234");
      mixAccountProfile.setProfile(itemId);
      assertEq(mixAccountProfile.getProfileByAccount(address(this)), itemId);

      itemId = mixItemStoreIpfsSha256.create(bytes2(0x0004), hex"1234");
      mixAccountProfile.setProfile(itemId);
      assertEq(mixAccountProfile.getProfileByAccount(address(this)), itemId);
    }

}
