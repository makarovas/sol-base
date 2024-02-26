contract AddressValidation {
    function validateAddress(string memory _addressString) public pure returns (address) {
        bytes memory tempStringBytes = bytes(_addressString);
        require(tempStringBytes.length == 42, "Invalid address length"); // Check length

        bytes memory addressBytes = new bytes(20);
        for (uint i = 0; i < 20; i++) {
            addressBytes[i] = tempStringBytes[i + 2]; // Exclude '0x' prefix
        }

        address convertedAddress = address(uint160(uint256(keccak256(addressBytes))));
        require(convertedAddress != address(0), "Invalid address format"); // Check if address is not zero

        return convertedAddress;
    }
}