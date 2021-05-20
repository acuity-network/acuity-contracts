// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "./AcuityReactions.sol";


contract AcuityReactionsProxy {

    AcuityReactions acuityReactions;

    constructor (AcuityReactions _acuityReactions) {
        acuityReactions = _acuityReactions;
    }

    function addReaction(bytes32 itemId, bytes4 reaction) external {
        acuityReactions.addReaction(itemId, reaction);
    }

    function removeReaction(bytes32 itemId, bytes4 reaction) external {
        acuityReactions.removeReaction(itemId, reaction);
    }

    function getReactionsByAccount(address account, bytes32 itemId) public view returns (bytes32) {
        return acuityReactions.getReactionsByAccount(account, itemId);
    }

    function getReactions(bytes32 itemId) external view returns (bytes32) {
        return acuityReactions.getReactions(itemId);
    }

    function getTrustedReactionsByAccount(address account, bytes32 itemId) public view returns (address[] memory itemReactionAccounts, bytes32[] memory itemReactions) {
        (itemReactionAccounts, itemReactions) = acuityReactions.getTrustedReactionsByAccount(account, itemId);
    }

    function getTrustedReactions(bytes32 itemId) external view returns (address[] memory itemReactionAccounts, bytes32[] memory itemReactions) {
        (itemReactionAccounts, itemReactions) =  acuityReactions.getTrustedReactions(itemId);
    }

}
