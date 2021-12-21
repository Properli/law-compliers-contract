
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const lawCompliersAgreement = artifacts.require("LawCompliersAgreement");

module.exports = async function (deployer) {
  const instance = await deployProxy(lawCompliersAgreement, { deployer });
  console.log('Deployed', instance.address);
};