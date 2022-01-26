// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;

import {ERC721} from "@solmate/tokens/ERC721.sol";
import {MerkleProof} from "@openzeppelin/utils/cryptography/MerkleProof.sol";
import {Strings} from "@openzeppelin/utils/Strings.sol";

error WrongEtherAmount();
error TokenDoesNotExist();
error InvalidProof();
error MaxSupplyReached();

/// @title MyNFT
/// @author Julian <juliancanderson@gmail.com>
contract MyNFT is ERC721 {
    using Strings for uint256;

    uint256 public immutable price = 0.1 ether;
    uint256 public immutable maxSupply = 10000;

    string public baseURI;
    uint256 public totalSupply;

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
        if (msg.value != price) revert WrongEtherAmount();

        if (totalSupply + 1 > maxSupply) revert MaxSupplyReached();

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        if (verifyMerkle(merkleProof, leaf)) {
            revert InvalidProof();
        }

        _mint(msg.sender, totalSupply++);
    }

    function verifyMerkle(bytes32[] calldata proof, bytes32 leaf)
        internal
        view
        returns (bool)
    {
        return MerkleProof.verify(proof, merkleRoot, leaf);
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
