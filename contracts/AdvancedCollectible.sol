// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract AdvancedCollectible is ERC721URIStorage, VRFConsumerBaseV2Plus{

        bytes32 immutable public KEY_HASH;
        uint256 immutable public SUBSCRIPTION_ID;
        uint256 public tokenCounter;
        address public ownerAddress;
    
        // Constants
        uint32 constant public CALLBACK_GAS_LIMIT = 1000000;
        uint16 constant public REQUEST_CONFORMATIONS = 3;
        uint32 constant public NUM_WORDS = 1;

        mapping(uint256 => address) public requestIdToSender;
        mapping(uint256 => BREED) public tokenIdToBreed;

        enum BREED{
            PUG,
            BULLDOG,
            BEAGLE,
            POODLE
        }

        string[] public tokenURIs = [
            "https://nft-backend-psi.vercel.app/1",
            "https://nft-backend-psi.vercel.app/2",
            "https://nft-backend-psi.vercel.app/3",
            "https://nft-backend-psi.vercel.app/4"
        ];

        event requestedCollectible(uint256 requestId, address creator);
        event breedAssignedToToken(uint256 tokenId, BREED breed);

        constructor(address _vrfCoordinator, uint256 _subscriptionId, bytes32 _keyHash) VRFConsumerBaseV2Plus(_vrfCoordinator) ERC721("Dogie", "Dog") {
            KEY_HASH = _keyHash;
            SUBSCRIPTION_ID = _subscriptionId;
            tokenCounter = 0;
            ownerAddress = msg.sender;
    }

    function createCollectible() public {
        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: KEY_HASH,
                subId: SUBSCRIPTION_ID,
                requestConfirmations: REQUEST_CONFORMATIONS,
                callbackGasLimit: CALLBACK_GAS_LIMIT,
                numWords: NUM_WORDS,
                // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
            })
        );

        requestIdToSender[requestId] = msg.sender;
        emit requestedCollectible(requestId, msg.sender);
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] calldata _randomWords) internal override {
        uint256 breedNumber = _randomWords[0] % 4;
        BREED breed = BREED(breedNumber);
        uint256 tokenId = tokenCounter;
        tokenIdToBreed[tokenId] = breed;
        emit breedAssignedToToken(tokenId, breed);
        _safeMint(requestIdToSender[_requestId], tokenId);
        _setTokenURI(tokenId, tokenURIs[breedNumber + 1]);
        tokenCounter = tokenCounter + 1;
    }
}