pragma solidity ^0.6.7;

import "../mix-item-store/AcuityItemStoreRegistry.sol";
import "./AcuityTokenInterface.sol";


/**
 * @title AcuityTokenItemRegistry
 * @author Jonathan Brown <jbrown@acuity.social>
 * @dev Contract to map tokens to their content items.
 */
contract AcuityTokenItemRegistry {

    /**
     * @dev Mapping of token to itemId.
     */
    mapping (address => bytes32) tokenItemId;

    /**
     * @dev Mapping of itemId to token.
     */
    mapping (bytes32 => address) itemIdToken;

    /**
     * @dev ItemStoreRegistry contract.
     */
    AcuityItemStoreRegistry public itemStoreRegistry;

    /**
     * @param _itemStoreRegistry Address of the ItemStoreRegistry contract.
     */
    constructor(AcuityItemStoreRegistry _itemStoreRegistry) public {
        // Store the address of the ItemStoreRegistry contract.
        itemStoreRegistry = _itemStoreRegistry;
    }

    /**
     * @dev register the content item for a token.
     * @param token Address of token contract.
     * @param itemId itemId of content item.
     */
    function register(AcuityTokenOwnedInterface token, bytes32 itemId) external {
        // Check token owner.
        require (token.owner() == msg.sender, "Token is not owned by sender.");
        // Check item.
        AcuityItemStoreInterface itemStore = itemStoreRegistry.getItemStore(itemId);
        require (itemStore.getOwner(itemId) == msg.sender, "Item is not owned by sender.");
        require (itemStore.getEnforceRevisions(itemId), "Item does not enforce revisions.");
        require (!itemStore.getRetractable(itemId), "Item is retractable.");
        // Check not registered before.
        require (tokenItemId[address(token)] == 0, "Token has been registered before.");
        require (itemIdToken[itemId] == address(0), "Item has been registered before.");
        // Record relationship.
        tokenItemId[address(token)] = itemId;
        itemIdToken[itemId] = address(token);
    }

    /**
     * @dev Get content item for token.
     * @param token Address of token contract.
     * @return itemId itemId of content item.
     */
    function getItemId(address token) external view returns (bytes32 itemId) {
        itemId = tokenItemId[token];
        require (itemId != 0, "Token not registered.");
    }

    /**
     * @dev Get token for content item.
     * @param itemId itemId of content item.
     * @return token Address of token contract.
     */
    function getToken(bytes32 itemId) external view returns (address token) {
        token = itemIdToken[itemId];
        require (token != address(0), "Item not registered.");
    }

}
