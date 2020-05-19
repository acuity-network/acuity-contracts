pragma solidity ^0.6.7;

import "../mix-item-store/MixItemStoreInterface.sol";
import "../mix-item-store/MixItemStoreRegistry.sol";
import "../mix-trusted-accounts/MixTrustedAccounts.sol";


/**
 * @title MixReactions
 * @author Jonathan Brown <jbrown@mix-blockchain.org>
 * @dev Enables users to react with emojis to content items.
 */
contract MixReactions {

    /**
     * @dev Mapping of itemId to mapping of account to packed array of 8 4-byte utf8 emojis.
     */
    mapping (bytes32 => mapping (address => bytes32)) itemAccountReactions;

    /**
     * @dev A reaction has been added to an item.
     * @param itemId Item having a reaction added.
     * @param itemOwner Owner of item having a reaction added.
     * @param reactor Account adding the reaction.
     * @param reaction Reaction being added.
     */
    event AddReaction(bytes32 indexed itemId, address indexed itemOwner, address indexed reactor, bytes4 reaction);

    /**
     * @dev A reaction has been removed from an item.
     * @param itemId Item having a reaction removed.
     * @param itemOwner Owner of item having a reaction removed.
     * @param reactor Account removing the reaction.
     * @param reaction Reaction being removed.
     */
     event RemoveReaction(bytes32 indexed itemId, address indexed itemOwner, address indexed reactor, bytes4 reaction);

     /**
      * @dev MixItemStoreRegistry contract.
      */
     MixItemStoreRegistry public itemStoreRegistry;

     /**
      * @dev MixTrustedAccounts contract.
      */
     MixTrustedAccounts public trustedAccounts;

     /**
      * @param _itemStoreRegistry Address of the MixItemStoreRegistry contract.
      * @param _trustedAccounts Address of the MixTrustedAccounts contract.
      */
     constructor(MixItemStoreRegistry _itemStoreRegistry, MixTrustedAccounts _trustedAccounts) public {
         // Store the address of the MixItemStoreRegistry contract.
         itemStoreRegistry = _itemStoreRegistry;
        // Store the address of the MixTrustedAccounts contract.
        trustedAccounts = _trustedAccounts;
    }

    function addReaction(bytes32 itemId, bytes4 reaction) external {
        // Get the current reactions of sender to item.
        bytes32 reactions = itemAccountReactions[itemId][msg.sender];

        bool added = false;
        for (uint shift = 0; shift < 256; shift += 32) {
            bytes4 reactionAtShift = bytes4(reactions << shift);
            if (!added && reactionAtShift == 0) {
                reactions |= bytes32(reaction) >> shift;
                added = true;
            }
            else if (reactionAtShift == reaction) {
                // The account has already added this reaction on this item.
                return;
            }
        }
        // Revert if there was not enough space to add the reaction.
        require (added, "No space to add reaction to item.");
        // Store the reactions slot back in state.
        itemAccountReactions[itemId][msg.sender] = reactions;
        // Log the adding of reaction.
        address owner = itemStoreRegistry.getItemStore(itemId).getOwner(itemId);
        emit AddReaction(itemId, owner, msg.sender, reaction);
    }

    function removeReaction(bytes32 itemId, bytes4 reaction) external {
        // Get the current reactions of sender to item.
        bytes32 reactions = itemAccountReactions[itemId][msg.sender];

        for (uint shift = 0; shift < 256; shift += 32) {
            if (bytes4(reactions << shift) == reaction) {
                reactions &= ~(bytes32(bytes4(uint32(-1))) >> shift);
                // Store the reactions slot back in state.
                itemAccountReactions[itemId][msg.sender] = reactions;
                // Log the removal of the reaction.
                address owner = itemStoreRegistry.getItemStore(itemId).getOwner(itemId);
                emit RemoveReaction(itemId, owner, msg.sender, reaction);
                break;
            }
        }
    }

    function getReactionsByAccount(address account, bytes32 itemId) public view returns (bytes32) {
        return itemAccountReactions[itemId][account];
    }

    function getReactions(bytes32 itemId) external view returns (bytes32) {
        return getReactionsByAccount(msg.sender, itemId);
    }

    function getTrustedReactionsByAccount(address account, bytes32 itemId) public view returns (address[] memory itemReactionAccounts, bytes32[] memory itemReactions) {
        // Get storage mapping of accounts to reactions for this item.
        mapping (address => bytes32) storage accountReactions = itemAccountReactions[itemId]; // check if this saves gas
        // Get list of accounts trusted by this account.
        address[] memory trusted = trustedAccounts.getAllTrustedByAccount(account);
        // Create empty array of reactions of each trusted account.
        bytes32[] memory trustedReactions = new bytes32[](trusted.length);
        // Check all trusted accounts.
        uint count = 0;
        for (uint i = 0; i < trusted.length; i++) {
            // Get the reactions this trusted account made to this item.
            bytes32 reactions = accountReactions[trusted[i]];
            if (reactions != 0) {
                // Store the reactions in memory.
                trustedReactions[i] = reactions;
                count++;
            }
        }
        // Now we know the size of the results, create the arrays.
        itemReactionAccounts = new address[](count);
        itemReactions = new bytes32[](count);
        // Loop through all trusted accounts again (without accessing state).
        uint j = 0;
        for (uint i = 0; i < trusted.length; i++) {
            // If the account made a reaction store it in the results.
            if (trustedReactions[i] != 0) {
                itemReactionAccounts[j] = trusted[i];
                itemReactions[j++] = trustedReactions[i];
            }
        }
    }

    function getTrustedReactions(bytes32 itemId) external view returns (address[] memory itemReactionAccounts, bytes32[] memory itemReactions) {
        (itemReactionAccounts, itemReactions) = getTrustedReactionsByAccount(msg.sender, itemId);
    }

}
