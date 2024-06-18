from scripts.helpful_scripts import get_account, OPENSEA_URL
from brownie import AdvancedCollectible, config, network


def deploy():
    account = get_account()
    AdvancedCollectible.deploy(config["networks"][network.show_active()]["vrf_coordinator"], config["networks"][network.show_active()]["subscription_id"], config["networks"][network.show_active()]["key_hash"], {"from": account})

def createCollectible():
        account = get_account()
        advanced_collectible = AdvancedCollectible[-1]
        txn = advanced_collectible.createCollectible({"from": account})
        txn.wait(1)
        print("new token created")
        print(f"Your nft has been deployed and can be viewed at {OPENSEA_URL.format(advanced_collectible.address, advanced_collectible.tokenCounter() - 1)}")

def main():
    # deploy()
    createCollectible()