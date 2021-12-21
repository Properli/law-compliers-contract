// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.3 <0.9.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// TODO: implement roles -> https://docs.openzeppelin.com/contracts/4.x/api/access#AccessControl

/**
 * @title Law Abiders Agreement
 * @dev Publish license agreement offering for single digital good
 */
contract LawCompliersAgreement is Initializable {
    
    /**
     * @dev a subscription consists of the subscriber's ethereum address and a unique identifier that identifies the subscriber off-chain
     */
    struct Subscription {
        address subscriberAddress;
        string subscriberId;
    }

    /**
     * @dev data structure that stores all license agreements to creators' digital goods with multiple subscribers
     */
    struct DigitalCopyrightProtectionCollection {
        string creatorId;
        string license;
        Subscription[] subscriptions;
    }

    mapping (uint => DigitalCopyrightProtectionCollection) copyrightRegistrations;

    function initialize() public initializer {}

    function registerDigitalGood(uint watermark, string calldata creatorId, string calldata license) external returns (DigitalCopyrightProtectionCollection memory) {
        require(bytes(copyrightRegistrations[watermark].creatorId).length == 0, "Encountered a hash collision. Aborting operation.");
        DigitalCopyrightProtectionCollection storage dcpc = copyrightRegistrations[watermark];
        dcpc.creatorId = creatorId;
        dcpc.license = license;
        return dcpc;
    }

    function readAgreement(uint watermark) external view returns (DigitalCopyrightProtectionCollection memory dcpc) {
        return copyrightRegistrations[watermark];
    }

    function readSubscriptions(uint watermark) external view returns (Subscription[] memory subs) {
        return copyrightRegistrations[watermark].subscriptions;
    }
    
    /**
     * @dev Saves and publicly announces aggreement to license terms of digital good
     * @param subscriberId unique identifier of subscriber for off-chain accountability
     */
    function agreeToTermsAndSubscribe(uint watermark, string calldata subscriberId) external returns (DigitalCopyrightProtectionCollection memory, Subscription memory) {
        // check if digital good even exists
        require(bytes(copyrightRegistrations[watermark].creatorId).length != 0, "The digital good you are trying to subscribe to was not yet registered. Make sure the watermark is calculated correctly or contact the creator.");
        // add subscription to contract storage
        copyrightRegistrations[watermark].subscriptions.push() = Subscription(msg.sender, subscriberId);
        return (
            copyrightRegistrations[watermark],
            copyrightRegistrations[watermark].subscriptions[
                copyrightRegistrations[watermark].subscriptions.length - 1
            ]);
    }
}