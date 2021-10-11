// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

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
        string subscriberId;
    }

    /**
     * @dev data structure that stores all license agreements to creators' digital goods with multiple subscribers
     */
    struct DigitalGoodCopyrightProtectionCollection {
        uint creatorId;
        uint watermark;
        string license;
    }
    
    mapping (uint => DigitalGoodCopyrightProtectionCollection) private copyrightRegistrations;

    mapping (uint => Subscription[]) subscriptions;

    /**
     * @param fromAddress Ethereum address from where the subscription request originated
     * @param subscriberId a unique identifier that identifies the subscriber behind/together with/to the Ethereum address
     */
    event NewSubscription(address indexed fromAddress, string indexed subscriberId);

    function initialize() public initializer {}

    function registerDigitalGood(uint creatorId, uint watermark, string calldata license) external returns (DigitalGoodCopyrightProtectionCollection memory) {
        copyrightRegistrations[watermark] = DigitalGoodCopyrightProtectionCollection({
            creatorId: creatorId,
            watermark: watermark,
            license: license
        });

        return copyrightRegistrations[watermark];
    }
    
    /**
     * @dev Saves and publicly announces aggreement to license terms of digital good
     * @param subscriberId unique identifier of subscriber for off-chain accountability
     */
    function agreeToTermsAndSubscribe(uint watermark, string calldata subscriberId) external returns (DigitalGoodCopyrightProtectionCollection memory, Subscription[] memory) {
        // check if digital good even exists
        require(copyrightRegistrations[watermark].watermark != 0, "The digital good you are trying to subscribe to was not yet registered. Make sure the watermark is calculated correctly or contact the creator.");
        // add subscription to contract storage
        subscriptions[watermark]
            .push(
                Subscription(
                    msg.sender,
                    subscriberId
                )
            );
        // publicly announce subscription
        emit NewSubscription(msg.sender, subscriberId);
        return (copyrightRegistrations[watermark], subscriptions[watermark]);
    }
    
    /**
     * @dev get all subscriptions of this contract
     */
    function readSubscriptions(uint watermark) external view returns(DigitalGoodCopyrightProtectionCollection memory, Subscription[] memory) {
        return (copyrightRegistrations[watermark], subscriptions[watermark]);
    }
}
