pragma solidity ^0.6.7;

import "../acuity-item-store/AcuityItemStoreInterface.sol";


contract AcuityItemMentions {

    /**
     * @dev Mapping of itemId to array of account addresses.
     */
    mapping (bytes32 => address[]) itemIdMentionAccounts;

    /**
     * @dev Mapping of account address to array of itemIds.
     */
    mapping (address => bytes32[]) accountMentionItemIds;

    /**
     * @dev An item has mentioned an account
     * @param account Address of the account being mentioned.
     * @param itemId itemId of the item mentioning the account.
     * @param i Index of the new item.
     */
    event AddItem(address account, bytes32 indexed itemId, uint i);

    /**
     * @dev Revert if a specific account mention does not exist.
     * @param account Address of the account.
     * @param i Index of the mention.
     */
    modifier accountMentionExists(address account, uint i) {
        require (i < accountMentionItemIds[account].length, "Account mention does not exist.");
        _;
    }

    /**
     * @dev Add an item to the list of items that mention an account. The item must not exist yet.
     * @param account Account to mention.
     * @param itemStore The ItemStore contract that will contain the item.
     * @param nonce The nonce that will be used to create the item.
     */
    function addItem(address account, AcuityItemStoreInterface itemStore, bytes32 nonce) external {
        // Get the itemId. Ensure it does not exist.
        bytes32 itemId = itemStore.getNewItemId(msg.sender, nonce);
        // Get the mentioned accounts list.
        address[] storage accounts = itemIdMentionAccounts[itemId];
        // Ensure the item does not have too many mentions.
        require (accounts.length < 20, "Item cannot mention more than 20 accounts.");
        // Store mappings.
        accountMentionItemIds[account].push(itemId);
        accounts.push(account);
        // Log the event.
        emit AddItem(account, itemId, accounts.length -1);
    }

    /**
     * @dev Get the number of mentions an account has.
     * @param account Address of the account.
     * @return The number of items.
     */
    function getMentionItemCount(address account) external view returns (uint) {
        return accountMentionItemIds[account].length;
    }

    /**
     * @dev Get a specific account mention.
     * @param account Address of the account.
     * @param i Index of the item.
     * @return itemId itemId of the mentioning item.
     */
    function getMentionItem(address account, uint i) external view accountMentionExists(account, i) returns (bytes32) {
        return accountMentionItemIds[account][i];
    }

    /**
     * @dev Get the all of an accounts mentions.
     * @param account Address of the account.
     * @return Array of itemIds of items that have mentioned this account.
     */
    function getAllMentionItems(address account) external view returns (bytes32[] memory) {
        return accountMentionItemIds[account];
    }

    /**
     * @dev Query an acount's mentions.
     * @param account Address of the account.
     * @param offset Index of the first itemId to retreive.
     * @param limit Maximum number of itemIds to retrieve.
     * @return itemIds The itemIds.
     */
    function getMentionItemsByQuery(address account, uint offset, uint limit) external view returns (bytes32[] memory itemIds) {
        // Get mention itemIds.
        bytes32[] storage mentionItemIds = accountMentionItemIds[account];
        // Check if offset is beyond the end of the array.
        if (offset >= mentionItemIds.length) {
            return new bytes32[](0);
        }
        // Check how many itemIds we can retrieve.
        uint _limit;
        if (offset + limit > mentionItemIds.length) {
            _limit = mentionItemIds.length - offset;
        }
        else {
            _limit = limit;
        }
        // Allocate memory array.
        itemIds = new bytes32[](_limit);
        // Populate memory array.
        for (uint i = 0; i < _limit; i++) {
            itemIds[i] = mentionItemIds[offset + i];
        }
    }

    /**
     * @dev Get the number of accounts an item has mentioned.
     * @param itemId itemId of the item.
     * @return The number of accounts.
     */
    function getItemMentionCount(bytes32 itemId) external view returns (uint) {
        return itemIdMentionAccounts[itemId].length;
    }

    /**
     * @dev Get the accounts an item has mentioned.
     * @param itemId itemId of the item.
     * @return The accounts.
     */
    function getItemMentions(bytes32 itemId) external view returns (address[] memory) {
        return itemIdMentionAccounts[itemId];
    }

}
