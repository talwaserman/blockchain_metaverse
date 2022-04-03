const Land = artifacts.require("Land");

module.exports = async function (deployer) {
    const NAME = 'my buildings';
    const SYMBOL = 'META_TAL';
    const CONST = web3.utils.toWei('1', 'ether');
    await deployer.deploy(Land, NAME, SYMBOL, CONST);
};
