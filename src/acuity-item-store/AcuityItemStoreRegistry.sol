// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.6;

import "./AcuityItemStoreConstants.sol";
import "./AcuityItemStoreInterface.sol";


/**
 * @title AcuityItemStoreRegistry
 * @author Jonathan Brown <jbrown@acuity.social>
 * @dev Maintains a registry of AcuityItemStoreInterface contracts.
 */
contract AcuityItemStoreRegistry is AcuityItemStoreConstants {

    /**
     * @dev Mapping of contractIds to contract addresses.
     */
    mapping (bytes32 => AcuityItemStoreInterface) contracts;

    /**
     * @dev A AcuityItemStoreInterface contract has been registered.
     * @param contractId Id of the contract.
     * @param contractAddress Address of the contract.
     */
    event Register(bytes8 indexed contractId, AcuityItemStoreInterface indexed contractAddress);

    /**
     * @dev Register the calling AcuityItemStoreInterface contract.
     * @return contractId Id of the AcuityItemStoreInterface contract.
     */
    function register() external returns (bytes32 contractId) {
        // Create contractId.
        contractId = keccak256(abi.encodePacked(msg.sender)) & CONTRACT_ID_MASK;
        // Make sure this contractId has not been used before (highly unlikely).
        require (contracts[contractId] == AcuityItemStoreInterface(0), "contractId already exists.");
        // Record the calling contract address.
        contracts[contractId] = AcuityItemStoreInterface(msg.sender);
        // Log the registration.
        emit Register(bytes8(contractId << 192), AcuityItemStoreInterface(msg.sender));
    }

    /**
     * @dev Lookup the itemStore contract for an item.
     * @param itemId itemId of the item to determine the itemStore contract of.
     * @return itemStore itemStore contract of the item.
     */
    function getItemStore(bytes32 itemId) external view returns (AcuityItemStoreInterface itemStore) {
        itemStore = contracts[itemId & CONTRACT_ID_MASK];
        require (address(itemStore) != address(0), "itemId does not have an itemStore contract.");
    }

}
