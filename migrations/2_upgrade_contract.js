const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const lawCompliersAgreement = artifacts.require('LawCompliersAgreement');
const new_lawCompliersAgreement = artifacts.require('LawCompliersAgreement'); // TODO

module.exports = async function (deployer) {
  const existing = await lawCompliersAgreement.deployed();
  const instance = await upgradeProxy(existing.address, new_lawCompliersAgreement, { deployer });
  console.log("Upgraded", instance.address);
};