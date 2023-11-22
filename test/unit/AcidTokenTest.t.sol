// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployAcidToken} from "../../script/DeployAcidToken.s.sol";
import {AcidToken} from "../../src/AcidToken.sol";

contract AcidTokenTest is Test {
    AcidToken public acidToken;
    DeployAcidToken public deployer;

    address stacce = makeAddr("stacce");
    address godi = makeAddr("godi");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployAcidToken();
        acidToken = deployer.run();

        vm.prank(msg.sender);
        acidToken.transfer(stacce, STARTING_BALANCE);
    }

    function test_StacceBalance() public {
        assertEq(acidToken.balanceOf(stacce), STARTING_BALANCE);
    }

    function test_TransferAllowances() public {
        // transferFrom
        uint256 initialAllowance = 700;

        // Stacce aproves Godi to spenk tokens on his behalf
        vm.prank(stacce);
        acidToken.approve(godi, initialAllowance);

        uint256 transferAmount = 300;

        vm.prank(godi);
        acidToken.transferFrom(stacce, godi, transferAmount);
        //? Why not use 'transfer'? Because it sets '_from' address to msg.sender
        assertEq(acidToken.balanceOf(godi), transferAmount);
        assertEq(
            acidToken.balanceOf(stacce),
            STARTING_BALANCE - transferAmount
        );
    }

    function test_AllowanceDecreases() public {
        // Stacce approves Godi to spend tokens on his behalf
        uint256 initialAllowance = 700;

        vm.prank(stacce);
        acidToken.approve(godi, initialAllowance);

        uint256 transferAmount = 300;

        vm.prank(godi);
        acidToken.transferFrom(stacce, godi, transferAmount);

        uint256 remainingAllowance = initialAllowance - transferAmount;
        assertEq(acidToken.allowance(stacce, godi), remainingAllowance);
    }

    function test_TransferToSelf() public {
        // Transfer tokens to the same account (self)
        uint256 transferAmount = 50;

        vm.prank(stacce);
        acidToken.transfer(stacce, transferAmount);

        assertEq(acidToken.balanceOf(stacce), STARTING_BALANCE);
    }

    function test_TransferToZeroAddress() public {
        // Transfer tokens to the zero address should revert
        (bool success, ) = address(acidToken).call(
            abi.encodeWithSelector(acidToken.transfer.selector, address(0), 50)
        );

        assertFalse(success, "Transfer to zero address should revert");
    }

    function test_TransferFromInsufficientAllowance() public {
        // Attempt transferFrom with insufficient allowance should revert
        uint256 initialAllowance = 50;

        vm.prank(stacce);
        acidToken.approve(godi, initialAllowance);

        vm.prank(godi);
        (bool success, ) = address(acidToken).call(
            abi.encodeWithSelector(
                acidToken.transferFrom.selector,
                stacce,
                godi,
                100
            )
        );

        assertFalse(
            success,
            "TransferFrom with insufficient allowance should revert"
        );
    }
}
