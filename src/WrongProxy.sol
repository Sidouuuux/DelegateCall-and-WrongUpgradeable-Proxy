// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Transparent upgradeable proxy pattern

contract CounterV1 {
    uint public count;

    function inc() external {
        count += 1;
    }
}

contract WrongProxy {
    address public implementation;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function _delegate() private {
        (bool ok, ) = implementation.delegatecall(msg.data);
        require(ok, "delegatecall failed");
    }

    fallback() external payable {
        _delegate();
    }

    receive() external payable {
        _delegate();
    }

    function upgradeTo(address _implementation) external {
        require(msg.sender == admin, "not authorized");
        implementation = _implementation;
    }
}