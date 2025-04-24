res = await ezkl.create_evm_verifier(
        vk_path,
        settings_path,
        'sol_verifier_contract_saved.sol',
        'abi_saved.abi',
    )

assert res == True
