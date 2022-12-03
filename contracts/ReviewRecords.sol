// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./OrderRecords.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ReviewRecords is Ownable {

    OrderRecords orderRecordsContract;

    struct record {
        uint32 orderId;
        address reviewBy;
        address reviewOf;
        string reviewCategory;
        string reviewDescription;
        uint rating;
    }

    mapping(uint32 => record) public records;
    uint32 reviewIdCounter = 1;

    function setOrderRecords(address contractAddress) public { //only owner
        orderRecordsContract = OrderRecords(contractAddress);
    }
  
    function addReview(record memory recordInfo) public {
        require(orderRecordsContract.accepted(recordInfo.orderId) == true);
        // validate already added
        records[reviewIdCounter++] = recordInfo;
    }
}