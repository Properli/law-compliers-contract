// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.3 <0.9.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// TODO: implement roles -> https://docs.openzeppelin.com/contracts/4.x/api/access#AccessControl

/**
 * @title Law Compliers Agreement
 * @dev Collection of published license agreement offerings for digital goods
 */
contract LawCompliersAgreement is Initializable {
    
    /**
     * @dev a subscription consists of the subscriber's ethereum address and a unique identifier that identifies the subscriber off-chain
     */
    struct Signature {
        address signerAddress;
        string signerId;
    }

    /**
     * @dev data structure that stores all license agreements to creators' digital goods with multiple subscribers
     */
    struct LicenseAgreementCollection {
        string creatorId;
        string license;
        Signature[] signatures;
    }

    mapping (uint => LicenseAgreementCollection) copyrightRegistrations;

    function initialize() public initializer {}

    /**
     * @dev initializes an entry in the copyrightRegistrations mapping. Used to register a digital good through its watermark with its license, and the creator's ID.
     * @param watermark the unique identifier that connects a license agreement to a digital good
     * @param creatorId the unique identifier that connects an agreement to its originator
     * @param license the license under which the creator publishes the digital good
     */
    function registerDigitalGood(uint watermark, string calldata creatorId, string calldata license) external returns (LicenseAgreementCollection memory) {
        require(bytes(copyrightRegistrations[watermark].creatorId).length == 0, "Encountered a hash collision. Aborting operation.");
        LicenseAgreementCollection storage lac = copyrightRegistrations[watermark];
        lac.creatorId = creatorId;
        lac.license = license;
        return lac;
    }

    /**
     * @dev return the digital license agreement of a watermark
     * @param watermark the unique identifier of a license agreement
     */
    function readAgreement(uint watermark) external view returns (LicenseAgreementCollection memory lac) {
        // check if digital good even exists
        require(bytes(copyrightRegistrations[watermark].creatorId).length != 0, "The digital good you are trying to subscribe to was not yet registered. Make sure the watermark is calculated correctly or contact the creator.");
        return copyrightRegistrations[watermark];
    }

    /**
     * @dev return the array of subscriptions of a registered digital good
     * @param watermark the unique identifier that is used to resolve the correct agreement
     */
    function readSignatures(uint watermark) external view returns (Signature[] memory sigs) {
        // check if digital good even exists
        require(bytes(copyrightRegistrations[watermark].creatorId).length != 0, "The digital good you are trying to subscribe to was not yet registered. Make sure the watermark is calculated correctly or contact the creator.");
        return copyrightRegistrations[watermark].signatures;
    }
    
    /**
     * @dev Saves and publicly announces aggreement to license terms of digital good
     * @param subscriberId unique identifier of subscriber for off-chain accountability
     */
    function agreeToTermsAndSubscribe(uint watermark, string calldata signerId) external returns (LicenseAgreementCollection memory, Signature memory) {
        // check if digital good even exists
        require(bytes(copyrightRegistrations[watermark].creatorId).length != 0, "The digital good you are trying to subscribe to was not yet registered. Make sure the watermark is calculated correctly or contact the creator.");
        // add subscription to contract storage
        copyrightRegistrations[watermark].signatures.push() = Signature(msg.sender, signerId);
        return (
            copyrightRegistrations[watermark],
            copyrightRegistrations[watermark].signatures[
                copyrightRegistrations[watermark].signatures.length - 1
            ]);
    }
}
