pragma solidity ^0.6.7;

import "./AcuityTrustedAccounts.sol";


contract AcuityTrustedAccountsProxy {

    AcuityTrustedAccounts mixTrustedAccounts;

    constructor (AcuityTrustedAccounts _mixTrustedAccounts) public {
        mixTrustedAccounts = _mixTrustedAccounts;
    }

    function trustAccount(address account) external {
        mixTrustedAccounts.trustAccount(account);
    }

    function untrustAccount(address account) external {
        mixTrustedAccounts.untrustAccount(account);
    }

    function getIsTrustedByAccount(address account, address accountToCheck) external view returns (bool) {
        return mixTrustedAccounts.getIsTrustedByAccount(account, accountToCheck);
    }

    function getIsTrusted(address accountToCheck) external view returns (bool) {
        return mixTrustedAccounts.getIsTrusted(accountToCheck);
    }

    function getIsTrustedByAccountMultiple(address account, address[] memory accountsToCheck) public view returns (bool[] memory results) {
        results = mixTrustedAccounts.getIsTrustedByAccountMultiple(account, accountsToCheck);
    }

    function getIsTrustedMultiple(address[] calldata accountsToCheck) external view returns (bool[] memory results) {
        results = mixTrustedAccounts.getIsTrustedMultiple(accountsToCheck);
    }

    function getIsTrustedOnlyDeepByAccount(address account, address accountToCheck) public view returns (bool) {
        return mixTrustedAccounts.getIsTrustedOnlyDeepByAccount(account, accountToCheck);
    }

    function getIsTrustedOnlyDeep(address accountToCheck) external view returns (bool) {
        return mixTrustedAccounts.getIsTrustedOnlyDeep(accountToCheck);
    }

    function getIsTrustedOnlyDeepByAccountMultiple(address account, address[] memory accountsToCheck) public view returns (bool[] memory results) {
        results = mixTrustedAccounts.getIsTrustedOnlyDeepByAccountMultiple(account, accountsToCheck);
    }

    function getIsTrustedOnlyDeepMultiple(address[] calldata accountsToCheck) external view returns (bool[] memory results) {
        results = mixTrustedAccounts.getIsTrustedOnlyDeepMultiple(accountsToCheck);
    }

    function getIsTrustedDeepByAccount(address account, address accountToCheck) public view returns (bool) {
        return mixTrustedAccounts.getIsTrustedDeepByAccount(account, accountToCheck);
    }

    function getIsTrustedDeep(address accountToCheck) external view returns (bool) {
        return mixTrustedAccounts.getIsTrustedDeep(accountToCheck);
    }

    function getIsTrustedDeepByAccountMultiple(address account, address[] memory accountsToCheck) public view returns (bool[] memory results) {
        results = mixTrustedAccounts.getIsTrustedDeepByAccountMultiple(account, accountsToCheck);
    }

    function getIsTrustedDeepMultiple(address[] calldata accountsToCheck) external view returns (bool[] memory results) {
        results = mixTrustedAccounts.getIsTrustedDeepMultiple(accountsToCheck);
    }

    function getTrustedCount() external view returns (uint) {
        return mixTrustedAccounts.getTrustedCount();
    }

    function getAllTrusted() external view returns (address[] memory) {
        return mixTrustedAccounts.getAllTrusted();
    }

    function getTrustedCountByAccount(address account) external view returns (uint) {
        return mixTrustedAccounts.getTrustedCountByAccount(account);
    }

    function getAllTrustedByAccount(address account) external view returns (address[] memory) {
        return mixTrustedAccounts.getAllTrustedByAccount(account);
    }

}
