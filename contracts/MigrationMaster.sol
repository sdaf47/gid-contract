pragma solidity ^0.4.4;

import "./Structures.sol";
import "./CrowdFunding.sol";

contract MigrationMaster is CrowdFunding {

    address oldContract;
    address newContract;

    function MigrationMaster() CrowdFunding() {}

    modifier onlyMigrationFrom {
        require(msg.sender == oldContract);
        _;
    }

    modifier onlyMigrationTo {
        require(msg.sender == newContract);
        _;
    }

    function setMigrationTo(address _newContract) onlyMaster {
        newContract = _newContract;
    }

    function setMigrationFrom(address _oldContract) onlyMaster {
        oldContract = _oldContract;
    }

    function iterate(function(address) external _callable) onlyMigrationTo returns(uint) {
        uint count = fundersList.length;
        uint i = 0;
        while(i < count) {
            address _addr = fundersList[i];
            _callable(_addr);
            i++;
        }
        return i;
    }

    function getFunder(address _address) onlyMigrationTo returns(uint _amountTokens, uint _amountWei) {
        _amountTokens = funders[_address].amountTokens;
        _amountWei = funders[_address].amountWei;
    }

    function migrateFunder(address _address) onlyMigrationFrom external {
        Structures.Funder storage funder = funders[_address];
        (funder.amountTokens, funder.amountWei) = MigrationMaster(msg.sender).getFunder(_address);
        balanceOf[_address] = funder.amountTokens;
    }

    function migrate(address _contract) onlyMaster {
        MigrationMaster(_contract).iterate(MigrationMaster(this).migrateFunder);
    }

    function migrateBalance() onlyMaster {
        newContract.transfer(this.balance);
    }

}
