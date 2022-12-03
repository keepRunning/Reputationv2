// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract OrderRecords {

    struct record {
        // uint32 orderId;
        address customer;
        address merchant;
        string detailLink;
        address initiator;
    }

    mapping(uint32 => record) public records;
    mapping(uint32 => bool) public accepted;
    uint32 orderIdCounter = 1;
  
    function addRecord(record memory recordInfo) public {
        require(msg.sender == recordInfo.customer || msg.sender == recordInfo.merchant);
        recordInfo.initiator = msg.sender;
        records[orderIdCounter++] = recordInfo;
    }

    function AcceptTransaction(uint32 recordId) public {
        require(records[recordId].initiator != address(0));
        require((msg.sender == records[recordId].customer || msg.sender == records[recordId].merchant) && records[recordId].initiator != msg.sender);
        accepted[recordId] = true;
    }
}