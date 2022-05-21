// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract PlotToken is ERC721, ERC721Enumerable, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
 
    struct Plot {
        uint priceInWei;
        uint paidWei;
    }

    mapping (uint => Plot) public priceMap;
    mapping (uint => uint) public tokenPrice;

    constructor() ERC721("PlotToken", "PLO") 
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://plot-token.sellbuy/metadata/";
    }

    function mintPlotToken(address to, uint _priceInWei) public {
        uint _tokenId = _tokenIdCounter.current();
        priceMap[_tokenId].priceInWei = _priceInWei;
        tokenPrice[_tokenIdCounter.current()] = _priceInWei;
        _tokenIdCounter.increment();
        super._safeMint(to, _tokenId);
    }

    function buyPlotToken(address from_buyer, address to_Owner, uint _tokenId) public payable {
        
        require(msg.value == priceMap[_tokenId].priceInWei, "We don't support partial payments");
        require(priceMap[_tokenId].paidWei == 0, "Item is already paid!");
        priceMap[_tokenId].paidWei += msg.value;

    }

    function _beforeTokenTransfer(address from, address to, uint _tokenId) internal override(ERC721, ERC721Enumerable) {
        require(! _exists(_tokenId) || priceMap[_tokenId].paidWei == priceMap[_tokenId].priceInWei ,"Token not bought");
        super._beforeTokenTransfer(from, to, _tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}