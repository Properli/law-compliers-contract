
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const lawAbidersAgreement = artifacts.require("lawAbidersAgreement");

module.exports = async function (deployer) {
  const instance = await deployProxy(lawAbidersAgreement, { deployer });
  console.log('Deployed', instance.address);
};