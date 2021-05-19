// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.4;

import "ds-test/test.sol";

import "./AcuityAccount.sol";


contract AcuityAccountTest is DSTest {

    AcuityAccount acuityAccount;
    AcuityAccountProxy acuityAccountProxy;
    Mock mock;

    receive() payable external {}

    function setUp() public {
        acuityAccount = new AcuityAccount();
        acuityAccountProxy = new AcuityAccountProxy(acuityAccount);
        mock = new Mock();
    }

    function testFailSetControllerNotController() public {
        acuityAccountProxy.setController(address(0x1234));
    }

    function testSetController() public {
        acuityAccount.setController(address(acuityAccountProxy));
        acuityAccountProxy.setController(address(0x1234));
    }

    function testSendCallSuccess() public {
        uint startBalance = address(this).balance;
        assertEq(address(mock).balance, 0);
        (bool success, bytes memory returnData) = acuityAccount.sendCall{value: 50}(address(mock), hex"cf7d0b9f");
        assertTrue(success);
        assertEq0(returnData, hex"000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000077375636365737300000000000000000000000000000000000000000000000000");
        assertEq(address(mock).balance, 50);
        assertEq(address(this).balance, startBalance - 50);
    }

    function testSendCallFail() public {
        uint startBalance = address(this).balance;
        assertEq(address(mock).balance, 0);
        (bool success, bytes memory returnData) = acuityAccount.sendCall{value: 50}(address(mock), hex"dad03cb0");
        assertTrue(!success);
        assertEq0(returnData, hex"08c379a0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000056572726f72000000000000000000000000000000000000000000000000000000");
        assertEq(address(mock).balance, 0);
        assertEq(address(this).balance, startBalance);
    }

    function testSendCallNoReturnSuccess() public {
        uint startBalance = address(this).balance;
        assertEq(address(mock).balance, 0);
        acuityAccount.sendCallNoReturn{value: 50}(address(mock), hex"cf7d0b9f");
        assertEq(address(mock).balance, 50);
        assertEq(address(this).balance, startBalance - 50);
    }

    function testSendCallNoReturnFail() public {
        uint startBalance = address(this).balance;
        assertEq(address(mock).balance, 0);
        acuityAccount.sendCallNoReturn{value: 50}(address(mock), hex"dad03cb0");
        assertEq(address(mock).balance, 0);
        assertEq(address(this).balance, startBalance);
    }

    function testControlWithdrawNotController() public {
        acuityAccount.withdraw();
    }

    function testFailWithdrawNotController() public {
        acuityAccountProxy.withdraw();
    }

    function testWithdraw() public {
        uint startAcuity = address(this).balance;
        assertEq(address(acuityAccount).balance, 0);
        address(acuityAccount).transfer(50);
        assertEq(address(acuityAccount).balance, 50);
        assertEq(address(this).balance, startAcuity - 50);
        acuityAccount.withdraw();
        assertEq(address(acuityAccount).balance, 0);
        assertEq(address(this).balance, startAcuity);
    }

    function testControlDestroyNotController() public {
        acuityAccount.destroy();
    }

    function testFailDestroyNotController() public {
        acuityAccountProxy.destroy();
    }

    function testDestroy() public {
        uint startAcuity = address(this).balance;
        assertEq(address(acuityAccount).balance, 0);
        address(acuityAccount).transfer(50);
        assertEq(address(acuityAccount).balance, 50);
        assertEq(address(this).balance, startAcuity - 50);
        acuityAccount.destroy();
        assertEq(address(acuityAccount).balance, 0);
        assertEq(address(this).balance, startAcuity);
    }

    function testCallback() public {
        address(acuityAccount).transfer(50);
    }

    function testOnERC1155Received() public {
        assertEq(bytes32(acuityAccountProxy.onERC1155Received(address(0), address(0), 0, 0, hex"")), bytes32(hex"f23a6e61"));
    }

    function testOnERC1155BatchReceived() public {
        uint[] memory empty = new uint[](0);
        assertEq(bytes32(acuityAccountProxy.onERC1155BatchReceived(address(0), address(0), empty, empty, hex"")), bytes32(hex"bc197c81"));
    }

    function testSupportsInterface() public {
        assertTrue(!acuityAccount.supportsInterface(0x00000000));
        assertTrue(!acuityAccount.supportsInterface(0xffffffff));
        assertTrue(acuityAccount.supportsInterface(0x01ffc9a7));    // EIP165
        assertTrue(acuityAccount.supportsInterface(0x4e2312e0));    // ERC1155TokenReceiver

        AcuityAccountInterfaceId acuityAccountInterfaceId = new AcuityAccountInterfaceId();
        assertTrue(acuityAccount.supportsInterface(acuityAccountInterfaceId.getInterfaceId()));
    }

}

contract AcuityAccountProxy is AcuityAccountInterface, ERC1155TokenReceiver {

    AcuityAccount acuityAccount;

    /**
     * @param _acuityAccount Real AcuityAccount contract to proxy to.
     */
    constructor (AcuityAccount _acuityAccount) {
        acuityAccount = _acuityAccount;
    }

    function setController(address payable newController) override external {
        acuityAccount.setController(newController);
    }

    function sendCall(address to, bytes calldata data) override external payable returns (bool success, bytes memory returnData) {
        (success, returnData) = acuityAccount.sendCall(to, data);
    }

    function sendCallNoReturn(address to, bytes calldata data) override external payable {
        acuityAccount.sendCallNoReturn(to, data);
    }

    function withdraw() override external {
        acuityAccount.withdraw();
    }

    function destroy() override external {
        acuityAccount.destroy();
    }

    receive() override payable external {}

    function onERC1155Received(address operator, address from, uint id, uint value, bytes calldata data) override external returns (bytes4) {
        return acuityAccount.onERC1155Received(operator, from, id, value, data);
    }

    function onERC1155BatchReceived(address operator, address from, uint[] calldata ids, uint[] calldata values, bytes calldata data) override external returns (bytes4) {
        return acuityAccount.onERC1155BatchReceived(operator, from, ids, values, data);
    }
}

contract Mock {

    receive() payable external {
        revert ("fallback error");
    }

    function returnNoError() public payable returns (string memory message) {
        message = "success";
    }

    function returnError() public payable {
        revert ("error");
    }

}
