// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {AcidToken} from "../src/AcidToken.sol";

contract DeployAcidToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1e7 ether;

    function run() external returns (AcidToken) {
        vm.startBroadcast();
        AcidToken acidToken = new AcidToken("AcidToken", "ACT", INITIAL_SUPPLY);
        vm.stopBroadcast();
        return acidToken;
    }
}
