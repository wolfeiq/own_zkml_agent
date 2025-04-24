# own_zkml_agent

Followed a [tutorial](https://dev.to/filosofiacodigoen/unruggable-ai-agents-with-zkml-4hf7) and customised it a little bit on the way to build a zkML agent that rewards users for writing useful comments using a custom ERC-20 token on Ethereum.

1. A user submits a comment.
2. The ML model scores all comments based on usefulness.
3. A ZK proof is generated to show the top comment was correctly chosen.
4. A Guadrail contract verifies the proof.
5. If valid, it calls a contract to send TIPT tokens to the commenter.

Used: 

Solidity ^0.8.22  
OpenZeppelin Contracts ^5.0  
Pytorch
[EZKL](https://github.com/zkonduit/ezkl) for proof generation
