// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0

pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RewardBestCommentor is ERC20, Ownable {
    address public aiAgent;

    event CommenterAwarded(address indexed to, uint256 amount, string commentId);

    constructor() ERC20("Tip Token", "TIPT") {
        _mint(msg.sender, 21_000_000 ether);
    }

    function setAiAgent(address _agent) external onlyOwner {
        aiAgent = _agent;
    }

    function awardUsefulComment(address recipient, uint256 amount, string calldata commentId) external {
        require(msg.sender == aiAgent, "Not authorized");
        _transfer(owner(), recipient, amount);
        emit CommenterAwarded(recipient, amount, commentId);
    }
}
