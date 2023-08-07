// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {WrongProxy, CounterV1} from "../src/WrongProxy.sol";

contract CounterTest is Test {
    CounterV1 public counterV1;
    CounterV1 public wrongCounterV1;
    WrongProxy public wrongProxy;

    function setUp() public {
        wrongProxy = new WrongProxy();
        counterV1 = new CounterV1();
        wrongCounterV1 = CounterV1(address(wrongProxy));
    }

    function testInc() public {
        // Check that the implementation address in wrongProxy contract is address(0)
        assertEq(
            wrongProxy.implementation(),
            address(0),
            "Incorrect wrongProxy implementation address"
        );

        // Check that the implementation address in wrongProxy contract was setted well
        wrongProxy.upgradeTo(address(counterV1));
        assertEq(
            wrongProxy.implementation(),
            address(counterV1),
            "WrongProxy implementation address not setted"
        );
        // Cast wrongProxy.implementation() address to uint and store it in beforeInc
        uint beforeInc = uint256(uint160(wrongProxy.implementation()));
        // increment count using the wrongCounterV1 contract
        wrongCounterV1.inc();

        // Cast wrongProxy.implementation() address to uint and store it in afterInc and check the result
        uint afterInc = uint256(uint160(wrongProxy.implementation()));
        assertEq(
            afterInc,
            beforeInc + 1,
            "WrongProxy implementation address not incremented"
        );
        // Count value in CounterV1 should not be updated
        assertEq(
            counterV1.count(),
            0,
            "WrongProxy implementation address not incremented"
        );
    }
     function testFailGetCount() public view{
        wrongCounterV1.count();
    }
}
