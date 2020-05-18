pragma solidity ^0.5.10;

import "mix-item-store/MixItemStoreRegistry.sol";


/**
 * @title MixAccountProfile
 * @author Jonathan Brown <jbrown@mix-blockchain.org>
 * @dev Enables each account to associate itself with a profile item.
 */
contract MixAccountProfile {

    /**
     * @dev Mapping of account to profile item.
     */
    mapping(address => bytes32) accountProfile;

    /**
     * @dev MixItemStoreRegistry contract.
     */
    MixItemStoreRegistry public itemStoreRegistry;

    /**
     * @dev An account has set its profile item.
     * @param account Account that has set its profile item.
     * @param itemId itemId of the profile.
     */
    event ProfileSet(address indexed account, bytes32 indexed itemId);

    /**
     * @dev Revert if the profile is not owned by the sender.
     * @param itemId itemId of the profile.
     */
    modifier isOwner(bytes32 itemId) {
        // Ensure the item is owned by the sender.
        require (itemStoreRegistry.getItemStore(itemId).getOwner(itemId) == msg.sender, "Item is not owned by sender.");
        _;
    }

    /**
     * @dev Revert if the account doesn't have a profile.
     * @param account Address of the account.
     */
    modifier hasProfile(address account) {
        // Ensure the profile has an account.
        require (accountProfile[account] != 0, "Account does not have a profile.");
        _;
    }

    /**
     * @dev Constructor.
     * @param _itemStoreRegistry Address of the MixItemStoreRegistry contract.
     */
    constructor(MixItemStoreRegistry _itemStoreRegistry) public {
        // Store the address of the MixItemStoreRegistry contract.
        itemStoreRegistry = _itemStoreRegistry;
    }

    /**
     * @dev Sets the profile for the sender.
     * @param itemId itemId of the profile.
     */
    function setProfile(bytes32 itemId) external isOwner(itemId) {
        // Store the itemId for the sender.
        accountProfile[msg.sender] = itemId;
        // Log the event.
        emit ProfileSet(msg.sender, itemId);
    }

    /**
     * @dev Gets the profile for the sender.
     */
    function getProfile() external view hasProfile(msg.sender) returns (bytes32) {
        return accountProfile[msg.sender];
    }

    /**
     * @dev Gets the profile for an account.
     * @param account Account to get the profile for.
     */
    function getProfileByAccount(address account) external view hasProfile(account) returns (bytes32) {
        return accountProfile[account];
    }

}
