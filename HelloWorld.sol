// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTransfer {
    address public sender;
    address public receiver;
    uint256 public amount;
    bool public isCompleted;

    event Transfer(address indexed _from, address indexed _to, uint256 _amount);

    constructor(address _receiver) {
        sender = msg.sender;
        receiver = _receiver;
        amount = 0;
        isCompleted = false;
    }

    function deposit() public payable {
        require(!isCompleted, "Transfer already completed");
        require(msg.sender == sender, "Only the sender can deposit");
        require(msg.value > 0, "Amount should be greater than 0");

        amount += msg.value;
        emit Transfer(sender, receiver, msg.value);
    }

    function withdraw() public {
        require(isCompleted, "Transfer not completed");
        require(msg.sender == receiver, "Only the receiver can withdraw");

        uint256 balance = amount;
        amount = 0;
        isCompleted = false;
        (bool success, ) = receiver.call{value: balance}("");
        require(success, "Transfer failed");
    }

    function completeTransfer() public {
        require(!isCompleted, "Transfer already completed");
        require(msg.sender == sender, "Only the sender can complete the transfer");

        isCompleted = true;
    }
}
