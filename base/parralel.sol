// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract AdvancedFeaturesContract is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    // Store oracle data fetch results
    mapping(bytes32 => uint256) public requestIdToData;

    // Event to emit oracle fetch results
    event DataFetched(bytes32 indexed requestId, uint256 data);

    constructor(address _oracle, bytes32 _jobId, uint256 _fee) {
        setPublicChainlinkToken();
        oracle = _oracle;
        jobId = _jobId;
        fee = _fee;
    }

    // Function to request data from Chainlink Oracle
    function requestDataFromOracle(
        string memory url,
        string memory path
    ) public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );
        request.add("get", url);
        request.add("path", path);
        int timesAmount = 10 ** 18; // Scale factor for numeric data
        request.addInt("times", timesAmount);
        requestId = sendChainlinkRequestTo(oracle, request, fee);
        return requestId;
    }

    // Callback function for Chainlink Oracle
    function fulfill(
        bytes32 _requestId,
        uint256 _data
    ) public recordChainlinkFulfillment(_requestId) {
        emit DataFetched(_requestId, _data);
        requestIdToData[_requestId] = _data;
    }

    function processData(
        bytes32 requestId
    ) public view returns (uint256 processedData) {
        require(requestIdToData[requestId] != 0, "Data not yet fetched");
        // Process the data deterministically
        processedData = requestIdToData[requestId] * 2; // Just example operation
        return processedData;
    }
}
