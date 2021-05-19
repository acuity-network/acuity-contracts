// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;

import "./AcuityAccount.sol";


/**
 * @title AcuityAccountRegistry
 * @author Jonathan Brown <jbrown@acuity.social>
 * @dev Enables controllers to store a record of which account they control.
 */
contract AcuityAccountRegistry {

    /**
     * @dev Mapping of controller to account.
     */
    mapping (address => AcuityAccount) controllerAccount;

    /**
     * @dev Revert if the controller does not have an account.
     */
    modifier accountExists(address controller) {
        require (controllerAccount[controller] != AcuityAccount(0), "Account not found.");
        _;
    }

    function set(AcuityAccount account) external {
        controllerAccount[msg.sender] = account;
    }

    function get(address controller) external view accountExists(controller) returns (AcuityAccount) {
        return controllerAccount[controller];
    }

}
