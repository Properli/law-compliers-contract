// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @title Law Abiders Agreement
 * @dev Publish license agreement offering for single digital good
 */
contract lawAbidersAgreement is Initializable {
    
    /**
     * A subscription consists of the subscriber's ethereum address and a unique identifier that identifies the subscriber off-chain
     */
    struct Subscription {
        address subscriberAddress;
        string subscriberId;
    }
    // list of all subscriptions
    Subscription[] public subscritionList;
    
    // unique identifier used to trace this contract back to a real person - can be an Ethereum address
    uint public CREATOR_ID;
    
    // calculated encryption of the combination of CREATOR_ID, the watermarked digital good, and the license
    uint public WATERMARK;
    
    // URL to a machine-readable license
    string public LICENSE;
    
    /**
     * @param fromAddress Ethereum address from where the subscription request originated
     * @param subscriberId a unique identifier that identifies the subscriber behind/together with/to the Ethereum address
     */
    event NewSubscription(address indexed fromAddress, string indexed subscriberId);

    /**
     * @dev Set values for constants CREATOR_ID, WATERMARK, and LICENSE
     * @param creatorId unique identifier for the creator of the digital good that is object of this agreement contract
     * @param watermark mathematical representation of the digital good - can only be calculated if there is access to the original digital good, the creatorId, and the license
     * @param license license that the digital good is distributed under - in most cases a URL to a machine-readable off-chain representation of a license
     */
    function initialize(uint creatorId, uint watermark, string memory license) public initializer {
        // initialize constants 
        CREATOR_ID = creatorId;
        WATERMARK = watermark;
        LICENSE = license;
    }

    
    /**
     * @dev Saves and publicly announces aggreement to license terms of digital good
     * @param subscriberId unique identifier of subscriber for off-chain accountability
     */
    function agreeToTermsAndSubscribe(string calldata subscriberId) external returns(Subscription memory) {
        // add subscription to contract storage
        subscritionList.push(Subscription(msg.sender, subscriberId));
        // publicly announce subscription
        emit NewSubscription(msg.sender, subscriberId);
        
        return Subscription(msg.sender, subscriberId);
    }
    
    /**
     * @dev get all subscriptions of this contract
     */
    function readSubscriptions() external view returns(Subscription[] memory) {
        return subscritionList;
    }
}
