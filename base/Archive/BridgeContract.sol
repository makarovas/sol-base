pragma solidity ^0.8.0;

import "./TokenDelegation.sol"; 
import "./StarknetTokenDelegationContract.cairo"; 

contract BridgeContract {
    address public evmContractAddress;
    StarknetTokenDelegationContract public starknetContract;

    constructor(address _evmContractAddress, address _starknetContractAddress) {
        evmContractAddress = _evmContractAddress;
        starknetContract = StarknetTokenDelegationContract(_starknetContractAddress);
    }

    function delegateToStarkNet(address starkNetDelegate) external {
        TokenDelegation tokenDelegation = TokenDelegation(evmContractAddress);
        tokenDelegation.delegateToStarkNet(starkNetDelegate);
    }

    function claimAndTransferTokens(address recipient, uint256 amount) external {
        starknetContract.claimTokens(recipient, amount);
        starknetContract.transferTokens(recipient, amount);
    }
}