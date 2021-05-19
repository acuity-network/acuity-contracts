// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;


/**
 * @title AcuityTokenInterface
 * @author Jonathan Brown <jbrown@acuity.social>
 * @dev Interface for MIX tokens.
 */
interface AcuityTokenInterface {
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function authorize(address account) external;
    function unauthorize(address account) external;
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function decimals() external view returns (uint);
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function getAccountAuthorized(address account, address accountToCheck) external view returns (bool);
}


/**
 * @title AcuityCreatorTokenInterfaceId
 * @author Jonathan Brown <jbrown@acuity.social>
 * @dev Contract to determine interface ID of AcuityTokenInterface.
 */
contract AcuityTokenInterfaceId {

    /**
     * @dev Get interface ID.
     * @return Interface ID.
     */
    function getInterfaceId() external pure returns (bytes4) {
        AcuityTokenInterface i;
        return i.transfer.selector ^
            i.transferFrom.selector ^
            i.authorize.selector ^
            i.unauthorize.selector ^
            i.symbol.selector ^
            i.name.selector ^
            i.decimals.selector ^
            i.totalSupply.selector ^
            i.balanceOf.selector ^
            i.getAccountAuthorized.selector;
    }

}


/**
 * @title AcuityTokenInterface
 * @author Jonathan Brown <jbrown@acuity.social>
 * @dev Interface for owned MIX tokens.
 */
interface AcuityTokenOwnedInterface {
    function owner() external view returns (address);
}


/**
 * @title AcuityCreatorTokenInterfaceId
 * @author Jonathan Brown <jbrown@acuity.social>
 * @dev Contract to determine interface ID of AcuityTokenOwnedInterface.
 */
contract AcuityTokenOwnedInterfaceId {

    /**
     * @dev Get interface ID.
     * @return Interface ID.
     */
    function getInterfaceId() external pure returns (bytes4) {
        AcuityTokenOwnedInterface i;
        return i.owner.selector;
    }

}
