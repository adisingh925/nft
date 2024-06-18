from scripts.helpful_scripts import get_account, OPENSEA_URL
from brownie import SimpleCollectible

def deploy():
    account = get_account()
    simple_collectible = SimpleCollectible.deploy({"from": account})
    txn = simple_collectible.createCollectible("https://ipfs.io/ipfs/QmXhpaPDhGi3uzrnkwuWEa6GsGtTK9gmEJ9HZBMEpfHxya")
    txn.wait(1)
    print(f"Your nft has been deployed and can be viewed at {OPENSEA_URL.format(simple_collectible.address, simple_collectible.tokenCounter() - 1)}")


def main():
    deploy()