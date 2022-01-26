// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;

import "@solmate/tokens/ERC721.sol";
import "./utils/Strings.sol";

error WrongEtherAmount();
error TokenDoesNotExist();

/// @title Greeter
/// @author Andreas Bigger <andreas@nascent.xyz>
contract MyNFT is ERC721 {
    using Strings for uint256;

    uint256 public immutable price = 0.1 ether;
    uint256 public immutable maxSupply = 10000;

    string public baseURI;

    bytes32 public merkleRoot =
        0x3fcf3077fd0856bf7cdce49a94e3e391b16cb1707afd9d03e17232b19977b7ad;

    constructor(
        string memory _name,
        string memory _symbol,
        bytes32 _merkleRoot,
        string memory _baseURI
    ) ERC721(_name, _symbol) {
        merkleRoot = _merkleRoot;
        baseURI = _baseURI;
    }

    function mintWhitelist(bytes32[] calldata merkleProof) external payable {
        if (msg.value != price) {
            revert WrongEtherAmount();
        }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (ownerOf[tokenId] == address(0)) {
            revert TokenDoesNotExist();
        }

        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
                : "";
    }
}
