const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const lawAbidersAgreement = artifacts.require('lawAbidersAgreement');
const new_lawAbidersAgreement = artifacts.require('lawAbidersAgreement'); // TODO

module.exports = async function (deployer) {
  const existing = await lawAbidersAgreement.deployed();
  const instance = await upgradeProxy(existing.address, new_lawAbidersAgreement, { deployer });
  console.log("Upgraded", instance.address);
};