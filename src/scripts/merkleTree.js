const { MerkleTree } = require("merkletreejs")
const keccak256 = require("keccak256")

var fs = require("fs")
var path = require("path")

const data = fs.readFileSync(path.join(__dirname, "./wallets.csv"), "utf8")

const leaves = data.split("\n").map((x) => keccak256(x))
const tree = new MerkleTree(leaves, keccak256)

console.log(tree.toString())
