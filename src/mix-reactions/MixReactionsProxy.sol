pragma solidity ^0.6.7;

import "./MixReactions.sol";


contract MixReactionsProxy {

    MixReactions mixReactions;

    constructor (MixReactions _mixReactions) public {
        mixReactions = _mixReactions;
    }

    function addReaction(bytes32 itemId, bytes4 reaction) external {
        mixReactions.addReaction(itemId, reaction);
    }

    function removeReaction(bytes32 itemId, bytes4 reaction) external {
        mixReactions.removeReaction(itemId, reaction);
    }

    function getReactionsByAccount(address account, bytes32 itemId) public view returns (bytes32) {
        return mixReactions.getReactionsByAccount(account, itemId);
    }

    function getReactions(bytes32 itemId) external view returns (bytes32) {
        return mixReactions.getReactions(itemId);
    }

    function getTrustedReactionsByAccount(address account, bytes32 itemId) public view returns (address[] memory itemReactionAccounts, bytes32[] memory itemReactions) {
        (itemReactionAccounts, itemReactions) = mixReactions.getTrustedReactionsByAccount(account, itemId);
    }

    function getTrustedReactions(bytes32 itemId) external view returns (address[] memory itemReactionAccounts, bytes32[] memory itemReactions) {
        (itemReactionAccounts, itemReactions) =  mixReactions.getTrustedReactions(itemId);
    }

}
