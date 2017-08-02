pragma solidity ^0.4.4;


import "./Structures.sol";
import "./Administrator.sol";


contract Verifier is Administrator {

    mapping (address => Structures.Verifier) public verifiers;

    modifier verifier {
        require(verifiers[msg.sender].active);
        _;
    }

    function appointVerifier(address _candidate, bytes32 _name) administration returns (bool status) {
        address[] memory _persons;
        Structures.Verifier memory verifier = Structures.Verifier({
        name : _name,
        personsDataApprove : _persons,
        administrator : msg.sender,
        active : true,
        block : false
        });
        verifiers[_candidate] = verifier;
    }

    function approvePerson(address _candidate) verifier returns (bool status) {
        persons[_candidate].verifier = msg.sender;
        verifiers[msg.sender].personsApprove[_candidate] = true;
        persons[_candidate].active = true;
        status = true;
    }

    function blockPerson(address _intruder) verifier returns (bool status) {
        persons[_intruder].active = false;
        persons[_intruder].block = true;
        address _verifier = persons[_intruder].verifier;
        verifiers[_verifier].personsApprove[_intruder] = false;
        status = true;
    }

}