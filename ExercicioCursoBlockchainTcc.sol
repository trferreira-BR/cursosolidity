/*
SPDX-License-Identifier: CC-BY-4.0
(c) Desenvolvido por Thiago R. Ferreira
This work is licensed under a Creative Commons Attribution 4.0 International License.
*/

pragma solidity 0.8.19;

import "https://github.com/jeffprestes/cursosolidity/blob/master/bradesco_token_aberto.sol";

// CONTRACT: 0x9A1d29d1EE52cB5C94c2A466D48dbA168e8a6a46

contract ExercicioCursoBlockchainTcc {

    Cliente private cliente;
    ExercicioToken private exercicioToken;
    Custodia private custodia;

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

        custodia = new Custodia(hashTemp, _enderecoContratoToken);
        cliente = Cliente(_primeiroNome, _sobreNome, payable(address(custodia)), hashTemp, true);

        exercicioToken = ExercicioToken(_enderecoContratoToken);
    }

    function meuSaldo() public view returns(uint256) {
        return custodia.meuSaldo();
    }

    function gerarTokenParaEuCliente(uint256 _amount) public returns (bool){
        return custodia.gerarTokens(_amount);
    }

    function saldoAtualCustodiaMoedaNativa() public view returns (uint){
        return custodia.saldoAtualMoedaNativa();
    }

    function transfereCriptomoeda(address _to, uint256 _amount) public returns (bool) {
        return custodia.transfereTokens(_to, _amount);
    }

}

contract Custodia {
    bytes32 private hashConta;
    ExercicioToken private token;
    address private cliente;

    event EtherRecebido();

    constructor(bytes32 _hashConta, address _enderecoToken) {
        hashConta = _hashConta;
        cliente = msg.sender;
        token = ExercicioToken(_enderecoToken);
    }

    function meuSaldo() public view returns(uint256) {
        //COMENTEI UMA POSSIVEL REGRA PARA PERMITIR QUE APENAS O CLIENTE CONSULTE O SALDO
        //require(msg.sender == cliente, "Somente o cliente pode consultar o saldo");
        return token.balanceOf(address(this));
    }

    function gerarTokens(uint256 _amount) public returns (bool){
        //COMENTEI UMA POSSIVEL REGRA PARA PERMITIR QUE O CLIENTE NAO GERE TOKENS PARA ELE MESMO
        //require(msg.sender != cliente, "Cliente nao pode gerar tokens para ele mesmo");
        return token.mint(address(this), _amount);
    }

    function transfereTokens(address _to, uint256 amount) public returns (bool){
        //COMENTEI UMA POSSIVEL REGRA PARA PERMITIR QUE APENAS O CLIENTE TRANSFIRA TOKENS
        //require(msg.sender == cliente, "Somente o cliente pode transferir seus proprios tokens");
        return token.transfer(_to, amount);
    }

    function saldoAtualMoedaNativa() public view returns (uint){
        return address(this).balance;
    }

    receive() external payable {
        emit EtherRecebido();
    }
    
}
