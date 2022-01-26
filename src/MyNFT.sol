// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;

import "@solmate/tokens/ERC721.sol";

/// @title Greeter
/// @author Andreas Bigger <andreas@nascent.xyz>
contract MyNFT is ERC721 {
    // put the merkle root + 0x from the merkleTree.js script here
    bytes32 public merkleRoot =
        0xa527e0dc1cfa5d86e65d1e30cecb1d985cdb5caf9792ca83df2b01a326b83edf;

    constructor(string memory _name, string memory _symbol)
        ERC721(name, symbol)
    {}

    function mintWhitelist() external {}
}
