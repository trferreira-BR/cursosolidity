/*
SPDX-License-Identifier: CC-BY-4.0
(c) Desenvolvido por Thiago R. Ferreira
This work is licensed under a Creative Commons Attribution 4.0 International License.
*/

pragma solidity 0.8.19;

import "https://github.com/jeffprestes/cursosolidity/blob/master/bradesco_token_aberto.sol";

// CONTRACT: 0x4069F00a9278e9EDEA491F4C71970055B8F1d1fA

contract ExercicioCursoBlockchainTcc {

    Cliente cliente;
    ExercicioToken exercicioToken;

    struct Cliente {
        string primeiroNome;
        string sobreNome;
        address payable endereco; //0x0
        bytes32 hashConta; // 0x0        
        bool existe; //false
    }

    constructor(
        string memory _primeiroNome,
        string memory _sobreNome,        
        string memory _agencia,
        string memory _conta,
        address _enderecoContratoToken) {

        string memory strTemp = string.concat(_agencia, _conta);
        bytes memory bTemp = bytes(strTemp);
        bytes32 hashTemp = keccak256(bTemp);

        Custodia custodiaTemp = new Custodia(hashTemp);
        cliente = Cliente(_primeiroNome, _sobreNome, payable(address(custodiaTemp)), hashTemp, true);

        exercicioToken = ExercicioToken(_enderecoContratoToken);
    }

    function meuSaldo() public view returns(uint256) {
        return exercicioToken.balanceOf(address(this));
    }

    function gerarTokenParaEuCliente(uint256 _amount) public returns (bool){
        return exercicioToken.mint(address(this), _amount);
    }

    function transfereTokens(address _to, uint256 amount) public returns (bool){
        return exercicioToken.transfer(_to, amount);
    }
}

contract Custodia {
    bytes32 public hashConta;

    event EtherRecebido();

    constructor(bytes32 _hashConta) {
        hashConta = _hashConta;
    }

    receive() external payable {
        emit EtherRecebido();
    }
    
}
