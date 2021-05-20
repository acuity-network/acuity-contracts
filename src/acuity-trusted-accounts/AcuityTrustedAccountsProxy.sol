// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "./AcuityTrustedAccounts.sol";


contract AcuityTrustedAccountsProxy {

    AcuityTrustedAccounts acuityTrustedAccounts;

    constructor (AcuityTrustedAccounts _acuityTrustedAccounts) {
        acuityTrustedAccounts = _acuityTrustedAccounts;
    }

    function trustAccount(address account) external {
        acuityTrustedAccounts.trustAccount(account);
    }

    function untrustAccount(address account) external {
        acuityTrustedAccounts.untrustAccount(account);
    }

    function getIsTrustedByAccount(address account, address accountToCheck) external view returns (bool) {
        return acuityTrustedAccounts.getIsTrustedByAccount(account, accountToCheck);
    }

    function getIsTrusted(address accountToCheck) external view returns (bool) {
        return acuityTrustedAccounts.getIsTrusted(accountToCheck);
    }

    function getIsTrustedByAccountMultiple(address account, address[] memory accountsToCheck) public view returns (bool[] memory results) {
        results = acuityTrustedAccounts.getIsTrustedByAccountMultiple(account, accountsToCheck);
    }

    function getIsTrustedMultiple(address[] calldata accountsToCheck) external view returns (bool[] memory results) {
        results = acuityTrustedAccounts.getIsTrustedMultiple(accountsToCheck);
    }

    function getIsTrustedOnlyDeepByAccount(address account, address accountToCheck) public view returns (bool) {
        return acuityTrustedAccounts.getIsTrustedOnlyDeepByAccount(account, accountToCheck);
    }

    function getIsTrustedOnlyDeep(address accountToCheck) external view returns (bool) {
        return acuityTrustedAccounts.getIsTrustedOnlyDeep(accountToCheck);
    }

    function getIsTrustedOnlyDeepByAccountMultiple(address account, address[] memory accountsToCheck) public view returns (bool[] memory results) {
        results = acuityTrustedAccounts.getIsTrustedOnlyDeepByAccountMultiple(account, accountsToCheck);
    }

    function getIsTrustedOnlyDeepMultiple(address[] calldata accountsToCheck) external view returns (bool[] memory results) {
        results = acuityTrustedAccounts.getIsTrustedOnlyDeepMultiple(accountsToCheck);
    }

    function getIsTrustedDeepByAccount(address account, address accountToCheck) public view returns (bool) {
        return acuityTrustedAccounts.getIsTrustedDeepByAccount(account, accountToCheck);
    }

    function getIsTrustedDeep(address accountToCheck) external view returns (bool) {
        return acuityTrustedAccounts.getIsTrustedDeep(accountToCheck);
    }

    function getIsTrustedDeepByAccountMultiple(address account, address[] memory accountsToCheck) public view returns (bool[] memory results) {
        results = acuityTrustedAccounts.getIsTrustedDeepByAccountMultiple(account, accountsToCheck);
    }

    function getIsTrustedDeepMultiple(address[] calldata accountsToCheck) external view returns (bool[] memory results) {
        results = acuityTrustedAccounts.getIsTrustedDeepMultiple(accountsToCheck);
    }

    function getTrustedCount() external view returns (uint) {
        return acuityTrustedAccounts.getTrustedCount();
    }

    function getAllTrusted() external view returns (address[] memory) {
        return acuityTrustedAccounts.getAllTrusted();
    }

    function getTrustedCountByAccount(address account) external view returns (uint) {
        return acuityTrustedAccounts.getTrustedCountByAccount(account);
    }

    function getAllTrustedByAccount(address account) external view returns (address[] memory) {
        return acuityTrustedAccounts.getAllTrustedByAccount(account);
    }

}
