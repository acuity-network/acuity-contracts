pragma solidity ^0.5.10;

import "ds-test/test.sol";

import "./MixAccountProfile.sol";

import "mix-item-store/MixItemStoreRegistry.sol";
import "mix-item-store/MixItemStoreIpfsSha256.sol";
import "mix-item-store/MixItemStoreIpfsSha256Proxy.sol";


contract MixAccountProfileTest is DSTest {

    MixItemStoreRegistry mixItemStoreRegistry;
    MixItemStoreIpfsSha256 mixItemStoreIpfsSha256;
    MixItemStoreIpfsSha256Proxy mixItemStoreIpfsSha256Proxy;
    MixAccountProfile mixAccountProfile;

    function setUp() public {
        mixItemStoreRegistry = new MixItemStoreRegistry();
        mixItemStoreIpfsSha256 = new MixItemStoreIpfsSha256(mixItemStoreRegistry);
        mixItemStoreIpfsSha256Proxy = new MixItemStoreIpfsSha256Proxy(mixItemStoreIpfsSha256);
        mixAccountProfile = new MixAccountProfile(mixItemStoreRegistry);
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
