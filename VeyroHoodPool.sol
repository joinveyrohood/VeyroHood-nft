// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VeyroHoodPool {
    address public owner;
    uint256 public minWithdraw;
    mapping(address => uint256) public pending;

    event Paid(address indexed user, address indexed referrer, uint256 total, uint256 cut);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(uint256 _minWithdrawWei) {
        owner = msg.sender;
        minWithdraw = _minWithdrawWei;
    }

    function setMinWithdraw(uint256 _minWithdrawWei) external {
        require(msg.sender == owner, "not owner");
        minWithdraw = _minWithdrawWei;
    }

    function verify(address referrer) external payable {
        require(msg.value > 0, "no value");
        uint256 cut = (msg.value * 20) / 100;
        uint256 rest = msg.value - cut;
        if (referrer != address(0) && referrer != msg.sender) {
            pending[referrer] += cut;
        } else {
            rest += cut;
        }
        (bool ok, ) = payable(owner).call{value: rest}("");
        require(ok, "owner send failed");
        emit Paid(msg.sender, referrer, msg.value, cut);
    }

    function withdraw() external {
        uint256 amt = pending[msg.sender];
        require(amt >= minWithdraw, "below minimum");
        pending[msg.sender] = 0;
        (bool ok, ) = payable(msg.sender).call{value: amt}("");
        require(ok, "withdraw failed");
        emit Withdrawn(msg.sender, amt);
    }
}
