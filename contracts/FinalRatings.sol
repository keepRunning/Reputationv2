// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./OrderRecords.sol";
import "./ReviewRecords.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FinalRatings is Ownable {
    address owner; // RatingsCalculator contract
    struct record {
        uint rating;
        uint prevRating;
        uint updateId;
    }
    mapping (address=>record) public ratings;

    function updateRating(address user, uint rating) public { //only owner
        // Update relevant ratings.
        // This is the publicly visible rating
    }
}
