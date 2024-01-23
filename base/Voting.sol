// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract VotingSystem {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public voters;

    uint public candidatesCounter;

    constructor(string[] memory candidatesNames) {
        for (uint i = 0; i < candidatesNames; i++) {
            addCandidate(candidatesNames[i]);
        }
    }

    function addCandidate(string memory name) private {
        candidatesCounter++;
        candidates[candidatesCounter] = Candidate(candidatesCounter, name, 0);
    }

    function vote(uint candidateId) public {
        require(!voters[msg.sender], "your have already voted");
        require(
            candidateId > 0 && candidateId <= candidatesCounter,
            "Invalid Candidate Id"
        );
        voters[msg.sender] = true;
        candidates[candidateId].voteCount++;
    }

    function getTotalVotes(uint candidateId) public view returns (uint) {
        require(
            candidateId > 0 && candidateId <= candidatesCounter,
            "Invalid Candidate Id"
        );
        return candidates[candidateId].voteCount;
    }
}

// Security and Audit:
// No functions are vulnerable to reentrancy attacks. In this contract, reentrancy is not a concern as there are no calls to external contracts.

// All user inputs are validated. This contract checks that the voter has not voted before and that the candidate ID is valid.

// Gas Optimization: Used memory for temporary variables and storage for permanent variables to optimize gas usage. This contract uses memory for the input in the constructor and storage for the mappings.

// Avoided Loops in Transactions: Loops that grow with the number of participants can cause the contract to hit the gas limit. Here, loops are only used in the constructor, which is acceptable.


