// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStarkNet {
    function claimTokens(address token, address recipient, uint256 amount) external;
    function transferTokens(address token, address recipient, uint256 amount) external;
}

contract TokenDelegation {
    struct ContractData {
        address owner;
        address delegate; 
        address starkNetContract;
    }
    ContractData contractData;

    mapping(address => TokenData) public tokensData;

    struct TokenData {
        address token;
        uint256 amount;
    }

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event DelegateChanged(address indexed previousDelegate, address indexed newDelegate);
    event TokensClaimed(address indexed token, address indexed recipient, uint256 amount);
    event TokensTransferred(address indexed token, address indexed recipient, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == contractData.owner, "Only the contract owner can perform this action");
        _;
    }

    constructor(address _starkNetContract) {
        contractData.owner = msg.sender;
        contractData.starkNetContract = _starkNetContract;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(contractData.owner, newOwner);
        contractData.owner = newOwner;
    }

    function setDelegate(address newDelegate) external onlyOwner {
        require(newDelegate != address(0), "Invalid address");
        contractData.delegate = newDelegate;
        emit DelegateChanged(contractData.delegate, newDelegate);
    }

    function delegateToStarkNet(address starkNetDelegate) external onlyOwner {
        require(starkNetDelegate != address(0), "Invalid StarkNet delegate address");
        contractData.delegate = starkNetDelegate;
        emit DelegateChanged(contractData.delegate, starkNetDelegate);
    }

    function claimTokens(address recipient, uint256 amount) external {
        require(contractData.delegate != address(0), "Delegate address not set");
        IStarkNet(contractData.starkNetContract).claimTokens(tokensData[msg.sender].token, recipient, amount);
        emit TokensClaimed(tokensData[msg.sender].token, recipient, amount);
    }

    function transferTokens(address recipient, uint256 amount) external {
        require(contractData.delegate != address(0), "Delegate address not set");
        IStarkNet(contractData.starkNetContract).transferTokens(tokensData[msg.sender].token, recipient, amount);
        emit TokensTransferred(tokensData[msg.sender].token, recipient, amount);
    }
}

