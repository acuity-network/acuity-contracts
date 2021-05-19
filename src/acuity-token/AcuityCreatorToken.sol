// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;

import "./ERC165.sol";
import "./AcuityTokenBase.sol";


/**
 * @title AcuityCreatorToken
 * @author Jonathan Brown <jbrown@acuity.social>
 * @dev MIX token that continually pays its owner.
 */
contract AcuityCreatorToken is AcuityTokenBase, AcuityTokenOwnedInterface {

    /**
     * @dev Address of the token owner account.
     */
    address override public owner;

    /**
     * @dev Timestamp of when the token was started.
     */
    uint public start;

    /**
     * @dev The balance the owner started with.
     */
    uint public initialBalance;

    /**
     * @dev How much the owner gets paid every day.
     */
    uint public dailyPayout;

    /**
     * @param symbol ERC-20 token currency code.
     * @param name ERC-20 token name.
     * @param _owner Address of the token owner.
     * @param _initialBalance Initial balance of the token owner.
     * @param _dailyPayout Daily payout to the token owner.
     */
    constructor(string memory symbol, string memory name, address _owner, uint _initialBalance, uint _dailyPayout) AcuityTokenBase(symbol, name) {
        // Make sure parameters are not too large.
        require (_initialBalance < uint224(-1), "Initial balance is too big.");
        require (_dailyPayout < uint192(-1), "Daily payout is too big.");
        // Store parameters in state.
        start = block.timestamp;
        owner = _owner;
        initialBalance = _initialBalance;
        dailyPayout = _dailyPayout;
    }

    /**
     * @dev Get the current total supply of the token.
     * @return The total quantity of the token in existance.
     */
    function totalSupply() override public view returns (uint) {
        return initialBalance + ((block.timestamp - start) * dailyPayout) / 1 days;
    }

    /**
    * @dev Get an account's token balance.
    * @param account Address of the account.
    * @return The account's token balance.
     */
    function balanceOf(address account) override public view returns (uint) {
        // Is account the token owner?
        if (account == owner) {
            return uint(accountBalance[account] + int(totalSupply()));
        }
        else {
            return uint(accountBalance[account]);
        }
    }

    /**
     * @dev Interface identification is specified in ERC-165.
     * @param interfaceId The interface identifier, as specified in ERC-165.
     * @return true if the contract implements interfaceId.
     */
    function supportsInterface(bytes4 interfaceId) override public view returns (bool) {
        return (AcuityTokenBase.supportsInterface(interfaceId) ||
            interfaceId == 0x8da5cb5b ||        // AcuityTokenOwnedInterface
            interfaceId == 0xd6559ea1);         // AcuityCreatorToken
    }

}


/**
 * @title AcuityCreatorTokenInterfaceId
 * @author Jonathan Brown <jbrown@acuity.social>
 * @dev Contract to determine interface ID of AcuityCreatorToken.
 */
contract AcuityCreatorTokenInterfaceId {

    /**
     * @dev Get interface ID.
     * @return Interface ID.
     */
    function getInterfaceId() external view returns (bytes4) {
        AcuityCreatorToken i;
        return i.start.selector ^
            i.initialBalance.selector ^
            i.dailyPayout.selector;
    }

}
