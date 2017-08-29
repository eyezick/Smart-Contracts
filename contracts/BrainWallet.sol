pragma solidity ^0.4.16;

// DISCLAIMER: Below code is NOT safe as contract could be watched waiting for the unhashed password
// to be sent, and a competing transaction with a higher gas price could be sent and mined before the original transaction
contract BrainWallet {

    bytes32 public password;

    //user hashes password offchain and includes hash in the creation of the contract
    function BrainWallet(bytes32 _password) {
        password = _password;
    }

    function getBalance() constant returns (uint) {
        return this.balance;
    }

    //changing the hash exposes the unhashed password, so the user includes a new hash in the same call
    function changePassword(string _password, bytes32 _newPassword) returns (bytes32) {
        require(sha3(_password) == password);

        password = _newPassword;
        return password;
    }

    //withdrawing also requires exposing the unhashed password, so a new password must also be set
    function withdraw(uint amount, string _password, bytes32 _newPassword) returns (bool){
        require(sha3(_password) == password);
        password = _newPassword;

        msg.sender.transfer(amount);
        return true;
    }

    function() payable {}
}