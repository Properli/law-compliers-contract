// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// TODO: implement roles -> https://docs.openzeppelin.com/contracts/4.x/api/access#AccessControl

/**
 * @title Law Abiders Agreement
 * @dev Publish license agreement offering for single digital good
 */
contract lawAbidersAgreement is Initializable {
    
    /**
     * @dev a subscription consists of the subscriber's ethereum address and a unique identifier that identifies the subscriber off-chain
     */
    struct Subscription {
        address subscriberAddress;
        bytes subscriberId;
    }

    /**
     * @dev data structure that stores all license agreements to creators' digital goods with multiple subscribers
     */
    struct DigitalCopyrightProtectionCollection {
        uint saltIndex;
        uint longAddressSalt;
        bytes creatorId;
        string license;
        Subscription[] subscriptions;
    }

    /**
     * @dev TODO
     * Iterable mapping adapted from https://docs.soliditylang.org/en/latest/types.html#iterable-mappings 
     */
    struct IterableCopyrightRegistrations {
        mapping (uint => DigitalCopyrightProtectionCollection) copyrightRegistrations;
        uint[] longSalts;
        uint size;
    }

    /**
     * @dev TODO
     */
    mapping (uint => IterableCopyrightRegistrations) private hashCollisionResolver;

    /**
     * @param fromAddress Ethereum address from where the subscription request originated
     * @param subscriberId a unique identifier that identifies the subscriber behind/together with/to the Ethereum address
     */
    event NewSubscription(address indexed fromAddress, bytes indexed subscriberId);

    function initialize() public initializer {}

    function registerDigitalGood(uint shortAddress, uint longAddress, uint longAddressSalt, bytes calldata creatorId, string calldata license) external returns (DigitalCopyrightProtectionCollection memory) {
        uint saltIndex = hashCollisionResolver[shortAddress].copyrightRegistrations[longAddress].saltIndex;
        require(saltIndex == 0, "Encountered a hash collision. The probability for this is smaller than 1 in a trillion. Just change one tiny thing in your work, try again, and you should be good. If not, start playing the lottery.");
        DigitalCopyrightProtectionCollection storage dcpc = hashCollisionResolver[shortAddress].copyrightRegistrations[longAddress];
        dcpc.longAddressSalt = longAddressSalt;
        dcpc.creatorId = creatorId;
        dcpc.license = license;
        saltIndex = hashCollisionResolver[shortAddress].longSalts.length;
        hashCollisionResolver[shortAddress].longSalts.push();
        dcpc.saltIndex = saltIndex + 1;
        hashCollisionResolver[shortAddress].longSalts[saltIndex] = longAddress;
        hashCollisionResolver[shortAddress].size++;     
        return dcpc;
    }

    function readSalts(uint shortAddress) external view returns (uint[] memory longSalts) {
        return hashCollisionResolver[shortAddress].longSalts;
    }

    function readContract(uint shortAddress, uint longAddress) external view returns (DigitalCopyrightProtectionCollection memory dcpc) {
        return hashCollisionResolver[shortAddress].copyrightRegistrations[longAddress];
    }

    function readSubscriptions(uint shortAddress, uint longAddress) external view returns (Subscription[] memory subs) {
        return hashCollisionResolver[shortAddress].copyrightRegistrations[longAddress].subscriptions;
    }
    
    /**
     * @dev Saves and publicly announces aggreement to license terms of digital good
     * @param subscriberId unique identifier of subscriber for off-chain accountability
     */
    function agreeToTermsAndSubscribe(uint shortAddress, uint longAddress, bytes calldata subscriberId) external returns (DigitalCopyrightProtectionCollection memory, Subscription memory) {
        // check if digital good even exists
        require(hashCollisionResolver[shortAddress].copyrightRegistrations[longAddress].saltIndex != 0, "The digital good you are trying to subscribe to was not yet registered. Make sure the watermark is calculated correctly or contact the creator.");
        // add subscription to contract storage
        hashCollisionResolver[shortAddress].copyrightRegistrations[longAddress].subscriptions.push() = Subscription(msg.sender, subscriberId);
        // publicly announce subscription
        emit NewSubscription(msg.sender, subscriberId);
        return (
            hashCollisionResolver[shortAddress].copyrightRegistrations[longAddress],
            hashCollisionResolver[shortAddress].copyrightRegistrations[longAddress].subscriptions[
                hashCollisionResolver[shortAddress].copyrightRegistrations[longAddress].subscriptions.length - 1
            ]);
    }
}
