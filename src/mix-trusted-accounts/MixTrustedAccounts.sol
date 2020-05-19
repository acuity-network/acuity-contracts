pragma solidity ^0.6.7;


/**
 * @title MixTrustedAccounts
 * @author Jonathan Brown <jbrown@mix-blockchain.org>
 * @dev Enables each account to maintain a public list of trusted accounts.
 */
contract MixTrustedAccounts {

    /**
     * @dev Mapping of account to array of trusted accounts.
     */
    mapping (address => address[]) accountTrustedAccountList;

    /**
     * @dev Mapping of account1 to mapping of account2 to index + 1 in accountTrustedAccountList.
     */
    mapping (address => mapping(address => uint)) accountTrustedAccountIndex;

    /**
     * @dev An account now trusts another account.
     * @param account Account that now trusts another account.
     * @param trusted Account being trusted.
     */
    event TrustAccount(address indexed account, address indexed trusted);

    /**
     * @dev An account now does not trust another account.
     * @param account Account that no longer trusts another account.
     * @param untrusted Account no longer being trusted.
     */
    event UntrustAccount(address indexed account, address indexed untrusted);

    /**
     * @dev Revert if the account is not trusted by the sender.
     * @param account Account that must be trusted.
     */
    modifier isTrusted(address account) {
        require (accountTrustedAccountIndex[msg.sender][account] > 0, "Account is not trusted by sender.");
        _;
    }

    /**
     * @dev Revert if the account is the sender.
     * @param account Account that must not be the sender.
     */
    modifier isNotSender(address account) {
        require (account != msg.sender, "Account is sender.");
        _;
    }

    /**
     * @dev Revert if the account is trusted by the sender.
     * @param account Account that must not be trusted.
     */
    modifier isNotTrusted(address account) {
        require (accountTrustedAccountIndex[msg.sender][account] == 0, "Account is trusted by sender.");
        _;
    }

    /**
     * @dev Record the sender as trusting an account.
     * @param account Account to be trusted by sender.
     */
    function trustAccount(address account) external isNotSender(account) isNotTrusted(account) {
        // Get the list of trusted accounts for sender.
        address[] storage trustedList = accountTrustedAccountList[msg.sender];
        // Add the new account to the list of accounts.
        trustedList.push(account);
        // Record the index + 1.
        accountTrustedAccountIndex[msg.sender][account] = trustedList.length;
        // Log the trusting of the account.
        emit TrustAccount(msg.sender, account);
    }

    /**
     * @dev Unrecord the sender as trusting an account.
     * @param account Account to not be trusted by sender.
     */
    function untrustAccount(address account) external isTrusted(account) {
        // Get the list of trusted accounts for sender.
        address[] storage trustedList = accountTrustedAccountList[msg.sender];
        // Get the mapping of trusted account indexes for sender.
        mapping(address => uint) storage trustedAccountIndex = accountTrustedAccountIndex[msg.sender];
        // Get the index + 1 of the account to be removed and delete it from state.
        uint i = trustedAccountIndex[account];
        delete trustedAccountIndex[account];
        // Check if this is not the last account.
        if (i != trustedList.length) {
          // Overwrite the account with the last account.
          address accountMoving = trustedList[trustedList.length - 1];
          trustedList[i - 1] = accountMoving;
          trustedAccountIndex[accountMoving] = i;
        }
        // Remove the last account.
        trustedList.pop();
        // Log the untrusting of account.
        emit UntrustAccount(msg.sender, account);
    }

    /**
     * @dev Check if an account trusts another account.
     * @param account Account to be checked if it trusts another account.
     * @param accountToCheck Account to be checked if it is trusted.
     * @return True if account trusts accountToCheck.
     */
    function getIsTrustedByAccount(address account, address accountToCheck) public view returns (bool) {
        return accountTrustedAccountIndex[account][accountToCheck] > 0;
    }

    /**
     * @dev Check if the sender trusts an account.
     * @param accountToCheck Account to be checked if it is trusted.
     * @return True if sender trusts accountToCheck.
     */
    function getIsTrusted(address accountToCheck) external view returns (bool) {
        return accountTrustedAccountIndex[msg.sender][accountToCheck] > 0;
    }

    /**
     * @dev Check if an account trusts multiple accounts.
     * @param account Account to be checked if it trusts multiple accounts.
     * @param accountsToCheck Accounts to be checked if they are trusted.
     * @return results Array of results.
     */
    function getIsTrustedByAccountMultiple(address account, address[] memory accountsToCheck) public view returns (bool[] memory results) {
        results = new bool[](accountsToCheck.length);
        for (uint i = 0; i < accountsToCheck.length; i++) {
            results[i] = accountTrustedAccountIndex[account][accountsToCheck[i]] > 0;
        }
    }

    /**
     * @dev Check if the sender trusts multiple accounts.
     * @param accountsToCheck Accounts to be checked if they are trusted.
     * @return results Array of results.
     */
    function getIsTrustedMultiple(address[] calldata accountsToCheck) external view returns (bool[] memory results) {
        results = getIsTrustedByAccountMultiple(msg.sender, accountsToCheck);
    }

    /**
     * @dev Check only deep if an account trusts another account.
     * @param account Account to be checked if it trusts an account.
     * @param accountToCheck Account to be checked if it is trusted.
     * @return True if account trusts accountToCheck.
     */
    function getIsTrustedOnlyDeepByAccount(address account, address accountToCheck) public view returns (bool) {
        // Check all the accounts trusted by account.
        address[] storage trustedList = accountTrustedAccountList[account];
        for (uint i = 0; i < trustedList.length; i++) {
            if (accountTrustedAccountIndex[trustedList[i]][accountToCheck] > 0) {
                return true;
            }
        }
        return false;
    }

    /**
     * @dev Check only deep if the sender trusts an account.
     * @param accountToCheck Account to be checked if it is trusted.
     * @return True if the sender trusts accountToCheck.
     */
    function getIsTrustedOnlyDeep(address accountToCheck) external view returns (bool) {
        return getIsTrustedOnlyDeepByAccount(msg.sender, accountToCheck);
    }

    /**
     * @dev Check only deep if the sender trusts multiple accounts.
     * @param account Account to be checked if it trusts multiple accounts.
     * @param accountsToCheck Accounts to be checked if they are trusted.
     * @return results Array of results.
     */
    function getIsTrustedOnlyDeepByAccountMultiple(address account, address[] memory accountsToCheck) public view returns (bool[] memory results) {
        results = new bool[](accountsToCheck.length);
        for (uint i = 0; i < accountsToCheck.length; i++) {
            results[i] = getIsTrustedOnlyDeepByAccount(account, accountsToCheck[i]);
        }
    }

    /**
     * @dev Check only deep if the sender trusts multiple accounts.
     * @param accountsToCheck Accounts to be checked if they are trusted.
     * @return results Array of results.
     */
    function getIsTrustedOnlyDeepMultiple(address[] calldata accountsToCheck) external view returns (bool[] memory results) {
        results = getIsTrustedOnlyDeepByAccountMultiple(msg.sender, accountsToCheck);
    }

    /**
     * @dev Check deep if an account trusts another account.
     * @param account Account to be checked if it trusts another account.
     * @param accountToCheck Account to be checked if it is trusted.
     * @return True if account trusts accountToCheck.
     */
    function getIsTrustedDeepByAccount(address account, address accountToCheck) public view returns (bool) {
        // Check if the sender trusts account.
        if (accountTrustedAccountIndex[account][accountToCheck] > 0) {
            return true;
        }
        return getIsTrustedOnlyDeepByAccount(account, accountToCheck);
    }

    /**
     * @dev Check deep if the sender trusts an account.
     * @param accountToCheck Account to be checked if it is trusted.
     * @return True if the sender trusts accountToCheck.
     */
    function getIsTrustedDeep(address accountToCheck) external view returns (bool) {
        return getIsTrustedDeepByAccount(msg.sender, accountToCheck);
    }

    /**
     * @dev Check deep if the sender trusts multiple accounts.
     * @param account Account to be checked if it trusts multiple accounts.
     * @param accountsToCheck Accounts to be checked if they are trusted.
     * @return results Array of results.
     */
    function getIsTrustedDeepByAccountMultiple(address account, address[] memory accountsToCheck) public view returns (bool[] memory results) {
        results = new bool[](accountsToCheck.length);
        for (uint i = 0; i < accountsToCheck.length; i++) {
            results[i] = getIsTrustedDeepByAccount(account, accountsToCheck[i]);
        }
    }

    /**
     * @dev Check deep if the sender trusts multiple accounts.
     * @param accountsToCheck Accounts to be checked if they are trusted.
     * @return results Array of results.
     */
    function getIsTrustedDeepMultiple(address[] calldata accountsToCheck) external view returns (bool[] memory results) {
        results = getIsTrustedDeepByAccountMultiple(msg.sender, accountsToCheck);
    }

    /**
     * @dev Get number of accounts trusted by sender.
     * @return Number of accounts trusted by sender.
     */
    function getTrustedCount() external view returns (uint) {
        return accountTrustedAccountList[msg.sender].length;
    }

    /**
     * @dev Get all accounts trusted by sender.
     * @return All accounts trusted by sender.
     */
    function getAllTrusted() external view returns (address[] memory) {
        return accountTrustedAccountList[msg.sender];
    }

    /**
     * @dev Get number of accounts trusted by account.
     * @return Number of accounts trusted by account.
     */
    function getTrustedCountByAccount(address account) external view returns (uint) {
        return accountTrustedAccountList[account].length;
    }

    /**
     * @dev Get all accounts trusted by account.
     * @param account Account to get accounts it trusts.
     * @return All accounts trusted by account.
     */
    function getAllTrustedByAccount(address account) external view returns (address[] memory) {
        return accountTrustedAccountList[account];
    }

    /**
     * @dev Get a list of trusted accounts that trust an account.
     * @param account Account to be checked who it trusts that trusts accountToCheck.
     * @param accountToCheck Account to check who trusts it.
     * @return results List of accounts that are trusted by account and trust accountToCheck.
     */
    function getTrustedThatTrustAccountByAccount(address account, address accountToCheck) public view returns (address[] memory results) {
        address[] storage trusted = accountTrustedAccountList[account];
        uint trustedCount = trusted.length;
        bool[] memory trustedTrust = new bool[](trustedCount);
        uint trustedTrustCount = 0;
        // Check which accounts that account trusts trust accountToCheck.
        for (uint i = 0; i < trustedCount; i++) {
            if (getIsTrustedByAccount(trusted[i], accountToCheck)) {
                trustedTrust[i] = true;
                trustedTrustCount++;
            }
        }
        // Store the results.
        results = new address[](trustedTrustCount);
        uint j = 0;
        for (uint i = 0; i < trustedCount; i++) {
            if (trustedTrust[i]) {
                results[j++] = trusted[i];
            }
        }
    }

    /**
     * @dev Get a list of trusted accounts that trust an account.
     * @param accountToCheck Account to check who trusts it.
     * @return results List of accounts that are trusted by sender and trust accountToCheck.
     */
    function getTrustedThatTrustAccount(address accountToCheck) external view returns (address[] memory results) {
        results = getTrustedThatTrustAccountByAccount(msg.sender, accountToCheck);
    }

}
