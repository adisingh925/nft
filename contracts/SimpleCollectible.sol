// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract SimpleCollectible is ERC721URIStorage {

    uint256 public tokenCounter;

    constructor() public ERC721 ("Puppie","PUP"){
        tokenCounter = 0;
    }

    function createCollectible(string memory tokenUri) public returns(uint256){
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenUri);
        tokenCounter = tokenCounter + 1;
        return newTokenId;
    }
}