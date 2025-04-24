// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface Halo2Verifier {
    function verifyProof(bytes calldata proof, uint256[] calldata instances) external view returns (bool);
}

interface Reward {
    function awardUsefulComment(address recipient, uint256 amount, string calldata commentId) external;
}


contract AiAgentGuardrail {
    address public immutable verifier_contract_address;
    Reward public immutable reward_contract_address;

    event ProofVerified(address indexed recipient, string commentId, uint256 amount);

    constructor(address _verifier, address rewards) {
        verifier_contract_address = _verifier;
        reward_contract_address = Reward(rewards);
    }

    function verifyAndSendTip(bytes memory proofCalldata, string calldata commentId) public {
        (bool success, bytes memory data) = verifier_contract_address.call(proofCalldata);

        if(success && data.length == 32 && uint8(data[31]) == 1)
            address recipient = extractTipRecipientFromProof(proofCalldata);
            uint256 rewardAmount = 1_000 ether;
            reward_contract_address.tipUserForUsefulComment(recipient, rewardAmount, commentId);
            emit ProofVerified(recipient, commentId, rewardAmount);
        else
            revert("Could not verify proof");
    }

    function extractTipRecipientFromProof(bytes memory proofCalldata) internal pure returns (address) {
        bytes memory lastBytes = new bytes(20);
        for (uint i = 0; i < 20; i++) {
            lastBytes[20-1-i] = proofCalldata[proofCalldata.length - (1+i*32)];
        }
        return address(bytes20(abi.encodePacked(lastBytes)));
    }
}
