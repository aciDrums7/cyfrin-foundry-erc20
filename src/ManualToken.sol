// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ManualToken {
    //? my address => 10 token
    mapping(address => uint256) private s_balances;

    //? These 2 are the same thing
    /* function name() public pure returns (string memory) {
        return "aciDToken";
    } */
    string public manualToken = "Manual Token";

    function totalSupply() public pure returns (uint256) {
        return 100 ether; // 100 000 000 000 000 000 000
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return s_balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        uint256 previousBalance = balanceOf(msg.sender) + balanceOf(_to);
        s_balances[msg.sender] -= _value;
        s_balances[_to] += _value;
        require(balanceOf(msg.sender) + balanceOf(_to) == previousBalance);
    }
}
