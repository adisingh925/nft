from brownie import network, accounts, config

OPENSEA_URL = "https://testnets.opensea.io/assets/sepolia/{}/{}"


def get_account(index=0):
    if(network.show_active() in "sepolia"):
        return accounts.add(config["wallets"]["from_key"])
    elif(network.show_active() in "mainnet-fork"):
        return accounts[0]