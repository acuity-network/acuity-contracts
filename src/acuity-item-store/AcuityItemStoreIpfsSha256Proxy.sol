// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "./AcuityItemStoreInterface.sol";
import "./AcuityItemStoreIpfsSha256.sol";


contract AcuityItemStoreIpfsSha256Proxy is AcuityItemStoreInterface {

    AcuityItemStoreIpfsSha256 acuityItemStoreIpfsSha256;

    constructor (AcuityItemStoreIpfsSha256 _acuityItemStore) {
        acuityItemStoreIpfsSha256 = _acuityItemStore;
    }

    function getNewItemId(address owner, bytes32 nonce) override public view returns (bytes32 itemId) {
        itemId = acuityItemStoreIpfsSha256.getNewItemId(owner, nonce);
    }

    function create(bytes32 flagsNonce, bytes32 ipfsHash) external returns (bytes32 itemId) {
        itemId = acuityItemStoreIpfsSha256.create(flagsNonce, ipfsHash);
    }

    function createNewRevision(bytes32 itemId, bytes32 ipfsHash) external returns (uint revisionId) {
        revisionId = acuityItemStoreIpfsSha256.createNewRevision(itemId, ipfsHash);
    }

    function updateLatestRevision(bytes32 itemId, bytes32 ipfsHash) external {
        acuityItemStoreIpfsSha256.updateLatestRevision(itemId, ipfsHash);
    }

    function retractLatestRevision(bytes32 itemId) override external {
        acuityItemStoreIpfsSha256.retractLatestRevision(itemId);
    }

    function restart(bytes32 itemId, bytes32 ipfsHash) external {
        acuityItemStoreIpfsSha256.restart(itemId, ipfsHash);
    }

    function retract(bytes32 itemId) override external {
        acuityItemStoreIpfsSha256.retract(itemId);
    }

    function transfer(bytes32 itemId, address recipient) override external {
        acuityItemStoreIpfsSha256.transfer(itemId, recipient);
    }

    function disown(bytes32 itemId) override external {
        acuityItemStoreIpfsSha256.disown(itemId);
    }

    function setEnforceRevisions(bytes32 itemId) override external {
        acuityItemStoreIpfsSha256.setEnforceRevisions(itemId);
    }

    function setNotRetractable(bytes32 itemId) override external {
        acuityItemStoreIpfsSha256.setNotRetractable(itemId);
    }

    function setNotTransferable(bytes32 itemId) override external {
        acuityItemStoreIpfsSha256.setNotTransferable(itemId);
    }

    function transferEnable(bytes32 itemId) override external {
        acuityItemStoreIpfsSha256.transferEnable(itemId);
    }

    function transferDisable(bytes32 itemId) override external {
        acuityItemStoreIpfsSha256.transferDisable(itemId);
    }

    function setNotUpdatable(bytes32 itemId) override external {
        acuityItemStoreIpfsSha256.setNotUpdatable(itemId);
    }

    function getAbiVersion() override external view returns (uint) {
        return acuityItemStoreIpfsSha256.getAbiVersion();
    }

    function getContractId() override external view returns (bytes8) {
        return acuityItemStoreIpfsSha256.getContractId();
    }

    function getInUse(bytes32 itemId) override public view returns (bool) {
        return acuityItemStoreIpfsSha256.getInUse(itemId);
    }

    function getItem(bytes32 itemId) external view returns (byte flags, address owner, uint[] memory timestamps, bytes32[] memory ipfsHashes) {
        (flags, owner, timestamps, ipfsHashes) = acuityItemStoreIpfsSha256.getItem(itemId);
    }

    function getFlags(bytes32 itemId) override external view returns (byte) {
        return acuityItemStoreIpfsSha256.getFlags(itemId);
    }

    function getUpdatable(bytes32 itemId) override external view returns (bool) {
        return acuityItemStoreIpfsSha256.getUpdatable(itemId);
    }

    function getEnforceRevisions(bytes32 itemId) override external view returns (bool) {
        return acuityItemStoreIpfsSha256.getEnforceRevisions(itemId);
    }

    function getRetractable(bytes32 itemId) override external view returns (bool) {
        return acuityItemStoreIpfsSha256.getRetractable(itemId);
    }

    function getTransferable(bytes32 itemId) override external view returns (bool) {
        return acuityItemStoreIpfsSha256.getTransferable(itemId);
    }

    function getOwner(bytes32 itemId) override external view returns (address) {
        return acuityItemStoreIpfsSha256.getOwner(itemId);
    }

    function getRevisionCount(bytes32 itemId) override external view returns (uint) {
        return acuityItemStoreIpfsSha256.getRevisionCount(itemId);
    }

    function getRevisionTimestamp(bytes32 itemId, uint revisionId) override external view returns (uint) {
        return acuityItemStoreIpfsSha256.getRevisionTimestamp(itemId, revisionId);
    }

    function getAllRevisionTimestamps(bytes32 itemId) override external view returns (uint[] memory) {
        return acuityItemStoreIpfsSha256.getAllRevisionTimestamps(itemId);
    }

    function getRevisionIpfsHash(bytes32 itemId, uint revisionId) external view returns (bytes32) {
        return acuityItemStoreIpfsSha256.getRevisionIpfsHash(itemId, revisionId);
    }

    function getAllRevisionIpfsHashes(bytes32 itemId) external view returns (bytes32[] memory) {
        return acuityItemStoreIpfsSha256.getAllRevisionIpfsHashes(itemId);
    }

}
