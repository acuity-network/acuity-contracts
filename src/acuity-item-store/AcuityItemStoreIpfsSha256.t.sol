pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./AcuityItemStoreRegistry.sol";
import "./AcuityItemStoreConstants.sol";
import "./AcuityItemStoreIpfsSha256.sol";
import "./AcuityItemStoreIpfsSha256Proxy.sol";


contract AcuityItemStoreIpfsSha256Test is DSTest, AcuityItemStoreConstants {

    AcuityItemStoreRegistry acuityItemStoreRegistry;
    AcuityItemStoreIpfsSha256 acuityItemStoreIpfsSha256;
    AcuityItemStoreIpfsSha256Proxy acuityItemStoreIpfsSha256Proxy;

    function setUp() public {
        acuityItemStoreRegistry = new AcuityItemStoreRegistry();
        acuityItemStoreIpfsSha256 = new AcuityItemStoreIpfsSha256(acuityItemStoreRegistry);
        acuityItemStoreIpfsSha256Proxy = new AcuityItemStoreIpfsSha256Proxy(acuityItemStoreIpfsSha256);
    }

    function testControlCreateSameItemId() public {
        acuityItemStoreIpfsSha256.create(hex"1234", hex"1234");
        acuityItemStoreIpfsSha256.getNewItemId(address(this), hex"2345");
    }

    function testFailCreateSameItemId() public {
        acuityItemStoreIpfsSha256.create(hex"1234", hex"1234");
        acuityItemStoreIpfsSha256.getNewItemId(address(this), hex"1234");
    }

    function testGetNewItemId() public {
        assertEq((acuityItemStoreIpfsSha256.getNewItemId(address(this), hex"1234") & CONTRACT_ID_MASK) << 192, acuityItemStoreIpfsSha256.getContractId());
        assertEq(acuityItemStoreIpfsSha256.getNewItemId(address(this), hex"1234"), acuityItemStoreIpfsSha256.getNewItemId(address(this), hex"1234"));
        assertTrue(acuityItemStoreIpfsSha256.getNewItemId(address(this), hex"1234") != acuityItemStoreIpfsSha256.getNewItemId(address(this), hex"2345"));
        assertTrue(acuityItemStoreIpfsSha256.getNewItemId(address(this), hex"1234") != acuityItemStoreIpfsSha256.getNewItemId(address(0), hex"1234"));
    }

    function testCreate() public {
        bytes32 itemId0 = acuityItemStoreIpfsSha256.create(hex"0000", hex"1234");
        assertTrue(acuityItemStoreIpfsSha256.getInUse(itemId0));
        assertEq(acuityItemStoreIpfsSha256.getFlags(itemId0), 0);
        assertEq(acuityItemStoreIpfsSha256.getOwner(itemId0), address(this));
        assertTrue(!acuityItemStoreIpfsSha256.getUpdatable(itemId0));
        assertTrue(!acuityItemStoreIpfsSha256.getEnforceRevisions(itemId0));
        assertTrue(!acuityItemStoreIpfsSha256.getRetractable(itemId0));
        assertTrue(!acuityItemStoreIpfsSha256.getTransferable(itemId0));
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId0, 0), hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId0, 0), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId0), 1);

        bytes32 itemId1 = acuityItemStoreIpfsSha256.create(UPDATABLE | ENFORCE_REVISIONS | RETRACTABLE | TRANSFERABLE | DISOWN | bytes32(hex"0001"), hex"1234");
        assertTrue(acuityItemStoreIpfsSha256.getInUse(itemId1));
        assertEq(acuityItemStoreIpfsSha256.getFlags(itemId1), UPDATABLE | ENFORCE_REVISIONS | RETRACTABLE | TRANSFERABLE | DISOWN);
        assertEq(acuityItemStoreIpfsSha256.getOwner(itemId1), address(0));
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId1), 1);
        assertTrue(acuityItemStoreIpfsSha256.getUpdatable(itemId1));
        assertTrue(acuityItemStoreIpfsSha256.getEnforceRevisions(itemId1));
        assertTrue(acuityItemStoreIpfsSha256.getRetractable(itemId1));
        assertTrue(acuityItemStoreIpfsSha256.getTransferable(itemId1));
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId1, 0), hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId1, 0), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId1), 1);

        bytes32 itemId2 = acuityItemStoreIpfsSha256.create(UPDATABLE | ENFORCE_REVISIONS | RETRACTABLE | TRANSFERABLE | DISOWN | bytes32(hex"0002"), hex"2345");
        assertTrue(acuityItemStoreIpfsSha256.getInUse(itemId2));
        assertEq(acuityItemStoreIpfsSha256.getFlags(itemId2), UPDATABLE | ENFORCE_REVISIONS | RETRACTABLE | TRANSFERABLE | DISOWN);
        assertEq(acuityItemStoreIpfsSha256.getOwner(itemId2), address(0));
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId2), 1);
        assertTrue(acuityItemStoreIpfsSha256.getUpdatable(itemId2));
        assertTrue(acuityItemStoreIpfsSha256.getEnforceRevisions(itemId2));
        assertTrue(acuityItemStoreIpfsSha256.getRetractable(itemId2));
        assertTrue(acuityItemStoreIpfsSha256.getTransferable(itemId2));
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId2, 0), hex"2345");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId2, 0), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId2), 1);

        assertTrue(itemId0 != itemId1);
        assertTrue(itemId0 != itemId2);
        assertTrue(itemId1 != itemId2);
    }

    function testControlCreateNewRevisionNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"2345");
    }

    function testFailCreateNewRevisionNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.createNewRevision(itemId, hex"2345");
    }

    function testControlCreateNewRevisionNotUpdatable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"2345");
    }

    function testFailCreateNewRevisionNotUpdatable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(0, hex"1234");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"2345");
    }

    function testCreateNewRevision() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"00");
        uint revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"01");
        assertEq(revisionId, 1);
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"02");
        assertEq(revisionId, 2);
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"03");
        assertEq(revisionId, 3);
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"04");
        assertEq(revisionId, 4);
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"05");
        assertEq(revisionId, 5);
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"06");
        assertEq(revisionId, 6);
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"07");
        assertEq(revisionId, 7);
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"08");
        assertEq(revisionId, 8);
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"09");
        assertEq(revisionId, 9);
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"10");
        assertEq(revisionId, 10);
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"11");
        assertEq(revisionId, 11);
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"12");
        assertEq(revisionId, 12);
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"13");
        assertEq(revisionId, 13);
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId), 14);
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 0), hex"00");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 1), hex"01");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 2), hex"02");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 3), hex"03");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 4), hex"04");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 5), hex"05");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 6), hex"06");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 7), hex"07");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 8), hex"08");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 9), hex"09");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 10), hex"10");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 11), hex"11");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 12), hex"12");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 13), hex"13");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 0), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 1), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 2), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 3), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 4), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 5), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 6), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 7), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 8), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 9), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 10), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 11), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 12), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 13), 0);
    }

    function testControlUpdateLatestRevisionNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.updateLatestRevision(itemId, hex"2345");
    }

    function testFailUpdateLatestRevisionNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.updateLatestRevision(itemId, hex"2345");
    }

    function testControlUpdateLatestRevisionNotUpdatable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.updateLatestRevision(itemId, hex"2345");
    }

    function testFailUpdateLatestRevisionNotUpdatable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(0, hex"1234");
        acuityItemStoreIpfsSha256.updateLatestRevision(itemId, hex"2345");
    }

    function testControlUpdateLatestRevisionEnforceRevisions() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.updateLatestRevision(itemId, hex"2345");
    }

    function testFailUpdateLatestRevisionEnforceRevisions() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE | ENFORCE_REVISIONS, hex"1234");
        acuityItemStoreIpfsSha256.updateLatestRevision(itemId, hex"2345");
    }

    function testUpdateLatestRevision() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId), 1);
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 0), hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 0), 0);
        acuityItemStoreIpfsSha256.updateLatestRevision(itemId, hex"2345");
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId), 1);
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 0), hex"2345");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 0), 0);
    }

    function testControlRetractLatestRevisionNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"2345");
        acuityItemStoreIpfsSha256.retractLatestRevision(itemId);
    }

    function testFailRetractLatestRevisionNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"2345");
        acuityItemStoreIpfsSha256Proxy.retractLatestRevision(itemId);
    }

    function testControlRetractLatestRevisionNotUpdatable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"2345");
        acuityItemStoreIpfsSha256.retractLatestRevision(itemId);
    }

    function testFailRetractLatestRevisionNotUpdatable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"2345");
        acuityItemStoreIpfsSha256.setNotUpdatable(itemId);
        acuityItemStoreIpfsSha256.retractLatestRevision(itemId);
    }

    function testControlRetractLatestRevisionEnforceRevisions() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"2345");
        acuityItemStoreIpfsSha256.retractLatestRevision(itemId);
    }

    function testFailRetractLatestRevisionEnforceRevisions() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE | ENFORCE_REVISIONS, hex"1234");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"2345");
        acuityItemStoreIpfsSha256.retractLatestRevision(itemId);
    }

    function testControlRetractLatestRevisionDoesntHaveAdditionalRevisions() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"2345");
        acuityItemStoreIpfsSha256.retractLatestRevision(itemId);
    }

    function testFailRetractLatestRevisionDoesntHaveAdditionalRevisions() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.retractLatestRevision(itemId);
    }

    function testRetractLatestRevision() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"2345");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"3456");
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId), 3);
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 0), hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 1), hex"2345");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 2), hex"3456");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 0), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 1), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 2), 0);
        acuityItemStoreIpfsSha256.retractLatestRevision(itemId);
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId), 2);
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 0), hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 1), hex"2345");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 0), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 1), 0);
        acuityItemStoreIpfsSha256.retractLatestRevision(itemId);
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId), 1);
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 0), hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 0), 0);
    }

    function testControlRestartNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.restart(itemId, hex"2345");
    }

    function testFailRestartNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.restart(itemId, hex"2345");
    }

    function testControlRestartNotUpdatable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.restart(itemId, hex"2345");
    }

    function testFailRestartNotUpdatable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(0, hex"1234");
        acuityItemStoreIpfsSha256.restart(itemId, hex"2345");
    }

    function testControlRestartEnforceRevisions() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.restart(itemId, hex"2345");
    }

    function testFailRestartEnforceRevisions() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE | ENFORCE_REVISIONS, hex"1234");
        acuityItemStoreIpfsSha256.restart(itemId, hex"2345");
    }

    function testRestart() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"2345");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"3456");
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId), 3);
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 0), hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 1), hex"2345");
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 2), hex"3456");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 0), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 1), 0);
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 2), 0);
        acuityItemStoreIpfsSha256.restart(itemId, hex"4567");
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId), 1);
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 0), hex"4567");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 0), 0);
    }

    function testControlRetractNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(RETRACTABLE, hex"1234");
        acuityItemStoreIpfsSha256.retract(itemId);
    }

    function testFailRetractNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(RETRACTABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.retract(itemId);
    }

    function testControlRetractNotRetractable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(RETRACTABLE, hex"1234");
        acuityItemStoreIpfsSha256.retract(itemId);
    }

    function testFailRetractNotRetractable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(0, hex"1234");
        acuityItemStoreIpfsSha256.retract(itemId);
    }

    function testRetract() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(RETRACTABLE, hex"1234");
        assertTrue(acuityItemStoreIpfsSha256.getInUse(itemId));
        assertEq(acuityItemStoreIpfsSha256.getOwner(itemId), address(this));
        assertTrue(!acuityItemStoreIpfsSha256.getUpdatable(itemId));
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId), 1);
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 0), hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 0), 0);
        acuityItemStoreIpfsSha256.retract(itemId);
        assertTrue(acuityItemStoreIpfsSha256.getInUse(itemId));
        assertEq(acuityItemStoreIpfsSha256.getOwner(itemId), address(0));
        assertTrue(!acuityItemStoreIpfsSha256.getUpdatable(itemId));
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId), 0);
    }

    function testControlTransferEnableNotTransferable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.transferEnable(itemId);
    }

    function testFailTransferEnableNotTransferable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(0, hex"1234");
        acuityItemStoreIpfsSha256Proxy.transferEnable(itemId);
    }

    function testControlTransferDisableNotEnabled() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.transferEnable(itemId);
        acuityItemStoreIpfsSha256Proxy.transferDisable(itemId);
    }

    function testFailTransferDisableNotEnabled() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.transferDisable(itemId);
    }

    function testControlTransferNotTransferable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.transferEnable(itemId);
        acuityItemStoreIpfsSha256.transfer(itemId, address(acuityItemStoreIpfsSha256Proxy));
    }

    function testFailTransferNotTransferable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(0, hex"1234");
        acuityItemStoreIpfsSha256Proxy.transferEnable(itemId);
        acuityItemStoreIpfsSha256.transfer(itemId, address(acuityItemStoreIpfsSha256Proxy));
    }

    function testControlTransferNotEnabled() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.transferEnable(itemId);
        acuityItemStoreIpfsSha256.transfer(itemId, address(acuityItemStoreIpfsSha256Proxy));
    }

    function testFailTransferNotEnabled() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256.transfer(itemId, address(acuityItemStoreIpfsSha256Proxy));
    }

    function testControlTransferDisabled() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.transferEnable(itemId);
        acuityItemStoreIpfsSha256.transfer(itemId, address(acuityItemStoreIpfsSha256Proxy));
    }

    function testFailTransferDisabled() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.transferEnable(itemId);
        acuityItemStoreIpfsSha256Proxy.transferDisable(itemId);
        acuityItemStoreIpfsSha256.transfer(itemId, address(acuityItemStoreIpfsSha256Proxy));
    }

    function testTransfer() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getOwner(itemId), address(this));
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId), 1);
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 0), hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 0), 0);
        acuityItemStoreIpfsSha256Proxy.transferEnable(itemId);
        acuityItemStoreIpfsSha256.transfer(itemId, address(acuityItemStoreIpfsSha256Proxy));
        assertEq(acuityItemStoreIpfsSha256.getOwner(itemId), address(acuityItemStoreIpfsSha256Proxy));
        assertEq(acuityItemStoreIpfsSha256.getRevisionCount(itemId), 1);
        assertEq(acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, 0), hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, 0), 0);
    }

    function testControlDisownNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256.disown(itemId);
    }

    function testFailDisownNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.disown(itemId);
    }

    function testControlDisownNotTransferable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256.disown(itemId);
    }

    function testFailDisownNotTransferable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(0, hex"1234");
        acuityItemStoreIpfsSha256.disown(itemId);
    }

    function testDisown() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        assertEq(acuityItemStoreIpfsSha256.getOwner(itemId), address(this));
        acuityItemStoreIpfsSha256.disown(itemId);
        assertEq(acuityItemStoreIpfsSha256.getOwner(itemId), address(0));
    }

    function testControlSetNotUpdatableNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256.setNotUpdatable(itemId);
    }

    function testFailSetNotUpdatableNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.setNotUpdatable(itemId);
    }

    function testSetNotUpdatable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"1234");
        assertTrue(acuityItemStoreIpfsSha256.getUpdatable(itemId));
        acuityItemStoreIpfsSha256.setNotUpdatable(itemId);
        assertTrue(!acuityItemStoreIpfsSha256.getUpdatable(itemId));
    }

    function testControlSetEnforceRevisionsNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(0, hex"1234");
        acuityItemStoreIpfsSha256.setEnforceRevisions(itemId);
    }

    function testFailSetEnforceRevisionsNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(0, hex"1234");
        acuityItemStoreIpfsSha256Proxy.setEnforceRevisions(itemId);
    }

    function testSetEnforceRevisions() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(0, hex"1234");
        assertTrue(!acuityItemStoreIpfsSha256.getEnforceRevisions(itemId));
        acuityItemStoreIpfsSha256.setEnforceRevisions(itemId);
        assertTrue(acuityItemStoreIpfsSha256.getEnforceRevisions(itemId));
    }

    function testControlSetNotRetractableNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(RETRACTABLE, hex"1234");
        acuityItemStoreIpfsSha256.setNotRetractable(itemId);
    }

    function testFailSetNotRetractableNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(RETRACTABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.setNotRetractable(itemId);
    }

    function testSetNotRetractable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(RETRACTABLE, hex"1234");
        assertTrue(acuityItemStoreIpfsSha256.getRetractable(itemId));
        acuityItemStoreIpfsSha256.setNotRetractable(itemId);
        assertTrue(!acuityItemStoreIpfsSha256.getRetractable(itemId));
    }

    function testControlSetNotTransferableNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256.setNotTransferable(itemId);
    }

    function testFailSetNotTransferableNotOwner() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        acuityItemStoreIpfsSha256Proxy.setNotTransferable(itemId);
    }

    function testSetNotTransferable() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(TRANSFERABLE, hex"1234");
        assertTrue(acuityItemStoreIpfsSha256.getTransferable(itemId));
        acuityItemStoreIpfsSha256.setNotTransferable(itemId);
        assertTrue(!acuityItemStoreIpfsSha256.getTransferable(itemId));
    }

    function testGetAbiVersion() public {
        assertEq(acuityItemStoreIpfsSha256.getAbiVersion(), 0);
    }

    function testMultipleGetters() public {
        bytes32 itemId = acuityItemStoreIpfsSha256.create(UPDATABLE, hex"00");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"01");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"02");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"03");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"04");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"05");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"06");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"07");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"08");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"09");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"10");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"11");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"12");
        acuityItemStoreIpfsSha256.createNewRevision(itemId, hex"13");

        (byte flags, address owner, uint[] memory timestamps, bytes32[] memory ipfsHashes) = acuityItemStoreIpfsSha256.getItem(itemId);

        assertEq(flags, UPDATABLE);
        assertEq(owner, address(this));

        assertEq(timestamps.length, 14);
        assertEq(timestamps[0], 0);
        assertEq(timestamps[1], 0);
        assertEq(timestamps[2], 0);
        assertEq(timestamps[3], 0);
        assertEq(timestamps[4], 0);
        assertEq(timestamps[5], 0);
        assertEq(timestamps[6], 0);
        assertEq(timestamps[7], 0);
        assertEq(timestamps[8], 0);
        assertEq(timestamps[9], 0);
        assertEq(timestamps[10], 0);
        assertEq(timestamps[11], 0);
        assertEq(timestamps[12], 0);
        assertEq(timestamps[13], 0);

        assertEq(ipfsHashes.length, 14);
        assertEq(ipfsHashes[0], hex"00");
        assertEq(ipfsHashes[1], hex"01");
        assertEq(ipfsHashes[2], hex"02");
        assertEq(ipfsHashes[3], hex"03");
        assertEq(ipfsHashes[4], hex"04");
        assertEq(ipfsHashes[5], hex"05");
        assertEq(ipfsHashes[6], hex"06");
        assertEq(ipfsHashes[7], hex"07");
        assertEq(ipfsHashes[8], hex"08");
        assertEq(ipfsHashes[9], hex"09");
        assertEq(ipfsHashes[10], hex"10");
        assertEq(ipfsHashes[11], hex"11");
        assertEq(ipfsHashes[12], hex"12");
        assertEq(ipfsHashes[13], hex"13");

        timestamps = acuityItemStoreIpfsSha256.getAllRevisionTimestamps(itemId);

        assertEq(timestamps.length, 14);
        assertEq(timestamps[0], 0);
        assertEq(timestamps[1], 0);
        assertEq(timestamps[2], 0);
        assertEq(timestamps[3], 0);
        assertEq(timestamps[4], 0);
        assertEq(timestamps[5], 0);
        assertEq(timestamps[6], 0);
        assertEq(timestamps[7], 0);
        assertEq(timestamps[8], 0);
        assertEq(timestamps[9], 0);
        assertEq(timestamps[10], 0);
        assertEq(timestamps[11], 0);
        assertEq(timestamps[12], 0);
        assertEq(timestamps[13], 0);

        ipfsHashes = acuityItemStoreIpfsSha256.getAllRevisionIpfsHashes(itemId);

        assertEq(ipfsHashes.length, 14);
        assertEq(ipfsHashes[0], hex"00");
        assertEq(ipfsHashes[1], hex"01");
        assertEq(ipfsHashes[2], hex"02");
        assertEq(ipfsHashes[3], hex"03");
        assertEq(ipfsHashes[4], hex"04");
        assertEq(ipfsHashes[5], hex"05");
        assertEq(ipfsHashes[6], hex"06");
        assertEq(ipfsHashes[7], hex"07");
        assertEq(ipfsHashes[8], hex"08");
        assertEq(ipfsHashes[9], hex"09");
        assertEq(ipfsHashes[10], hex"10");
        assertEq(ipfsHashes[11], hex"11");
        assertEq(ipfsHashes[12], hex"12");
        assertEq(ipfsHashes[13], hex"13");
    }

}
