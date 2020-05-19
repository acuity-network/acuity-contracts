pragma solidity ^0.6.7;

import "../mix-item-store/MixItemStoreRegistry.sol";
import "./MixTokenItemRegistry.sol";
import "./ERC165.sol";
import "./MixTokenInterface.sol";


/**
 * @title MixTokenBase
 * @author Jonathan Brown <jbrown@mix-blockchain.org>
 * @dev Base contract for building MIX tokens.
 */
abstract contract MixTokenBase is ERC165, MixTokenInterface {

    /**
     * @dev Mapping of account account to account balance.
     */
    mapping (address => int) accountBalance;

    /**
     * @dev Mapping of account address to mapping of authorized account to authorized.
     */
    mapping (address => mapping (address => bool)) accountAuthorized;

    /**
     * @dev ERC-20 token currency code.
     */
    string override public symbol;

    /**
     * @dev ERC-20 token name.
     */
    string override public name;

    /**
     * @dev A token transfer has occured.
     * @param from Address tokens transferred from.
     * @param to Address tokens transferred to.
     * @param value Quantity of tokens transferred.
     */
    event Transfer(address indexed from, address indexed to, uint value);

    /**
     * @dev An account has been authorized to transfer tokens from another account.
     * @param account Account that may have its tokens transferred.
     * @param authorized Account that may transfer tokens.
     */
    event Authorize(address indexed account, address indexed authorized);

    /**
     * @dev An account has been unauthorized to transfer funds from another account.
     * @param account Account that may not have its tokens transferred.
     * @param unauthorized Account that may not transfer tokens.
     */
    event Unauthorize(address indexed account, address indexed unauthorized);

    /**
     * @dev Check if account has sufficient balance for transfer.
     * @param account Address of account to check.
     * @param value Quantity of tokens to be transferred.
     */
    modifier hasSufficientBalance(address account, uint value) {
        require (balanceOf(account) >= value, "Insufficient balance.");
        _;
    }

    /**
     * @dev Check if sender is authorized to transfer tokens from account.
     * @param account Address of account to check if sender can transfer tokens from.
     */
    modifier isAuthorized(address account) {
        require (accountAuthorized[account][msg.sender], "Not authorized.");
        _;
    }

    /**
     * @param _symbol ERC-20 token currency code.
     * @param _name ERC-20 token name.
     */
    constructor(string memory _symbol, string memory _name) public {
        symbol = _symbol;
        name = _name;
    }

    /**
     * @dev Update balances and log event for trasnfer.
     * @param from Address to transfer from.
     * @param to Address to transfer to.
     * @param value Quantity of tokens to transfer.
     */
    function _transfer(address from, address to, uint value) internal hasSufficientBalance(from, value) {
        // Update balances.
        accountBalance[from] -= int(value);
        accountBalance[to] += int(value);
        // Log the event.
        emit Transfer(from, to, value);
    }

    /**
     * @dev Transfer tokens from sender..
     * @param to Address to transfer to.
     * @param value Quantity of tokens to transfer.
     * @return True.
     */
    function transfer(address to, uint value) virtual override external returns (bool) {
        // Transfer the tokens.
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Transfer tokens from another account.
     * @param from Address to transfer from.
     * @param to Address to transfer to.
     * @param value Quantity of tokens to transfer.
     * @return True.
     */
    function transferFrom(address from, address to, uint value) virtual override external isAuthorized(from) returns (bool) {
        // Transfer the tokens.
        _transfer(from, to, value);
        return true;
    }

    /**
     * @dev Authorize account to transfer tokens from sender.
     * @param account Address of account to authorize.
     */
    function authorize(address account) virtual override external {
        accountAuthorized[msg.sender][account] = true;
        emit Authorize(msg.sender, account);
    }

    /**
     * @dev Unauthorize account to transfer tokens from sender.
     * @param account Address of account to unauthorize.
     */
    function unauthorize(address account) virtual override external {
        delete accountAuthorized[msg.sender][account];
        emit Unauthorize(msg.sender, account);
    }

    /**
     * @dev Get number of decimal places token has.
     * @return 18
     */
    function decimals() virtual override external view returns (uint) {
        return 18;
    }

    /**
     * @dev Get token balance of an account.
     * @param account Address of account to query.
     * @return Token balance of account.
     */
    function balanceOf(address account) virtual override public view returns (uint) {
        return uint(accountBalance[account]);
    }

    /**
     * @dev Determine if an account is authorized to transfer tokens from another account.
     * @param account Address of account for tokens to be sent from.
     * @param accountToCheck Address of account that should be checked if it is authorized to send funds.
     * @return True if accountToCheck is permited to transfer funds.
     */
    function getAccountAuthorized(address account, address accountToCheck) virtual override external view returns (bool) {
        return accountAuthorized[account][accountToCheck];
    }

    /**
     * @dev Interface identification is specified in ERC-165.
     * @param interfaceId The interface identifier, as specified in ERC-165.
     * @return true if the contract implements interfaceID.
     */
    function supportsInterface(bytes4 interfaceId) virtual override public view returns (bool) {
        return (interfaceId == 0x01ffc9a7 ||    // ERC165
            interfaceId == 0xa66762eb);         // MixTokenInterface
    }

}
