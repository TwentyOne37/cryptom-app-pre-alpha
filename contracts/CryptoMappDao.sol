// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CryptoMappDao {
    uint256 public transactionFee;
    uint256 public registrationFee;

    function setTransactionFee(uint256 _transactionFee) public {
        transactionFee = _transactionFee;
    }

    function setRegistrationFee(uint256 _registrationFee) public {
        registrationFee = _registrationFee;
    }
}
