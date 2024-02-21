type StarknetTokenDelegationContract is contract(
    tokenData : public map(address, {token : address, amount : felt}),
    contractData : public {owner : address, delegate : address}
)

init(owner : address, delegate : address) -> (contract : StarknetTokenDelegationContract):
    contract.contractData.owner := owner
    contract.contractData.delegate := delegate
    return contract

func setDelegate(contract : StarknetTokenDelegationContract, newDelegate : address):
    if calldata.sender != contract.contractData.owner:
        require false, "Only the contract owner can set delegate"
    contract.contractData.delegate := newDelegate

func claimTokens(contract : StarknetTokenDelegationContract, recipient : address, amount : felt):
    let tokenData = contract.tokenData[calldata.sender]
    if contract.contractData.delegate == 0:
        require false, "Delegate address not set"
    transfer(IERC20(tokenData.token), recipient, amount)

func transferTokens(contract : StarknetTokenDelegationContract, recipient : address, amount : felt):
    let tokenData = contract.tokenData[calldata.sender]
    if contract.contractData.delegate == 0:
        require false, "Delegate address not set"
    transfer(IERC20(tokenData.token), recipient, amount)