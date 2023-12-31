/*
SPDX-License-Identifier: CC-BY-4.0
(c) Desenvolvido por Thiago R. Ferreira
This work is licensed under a Creative Commons Attribution 4.0 International License.
*/

pragma solidity 0.8.19;

import "https://github.com/jeffprestes/cursosolidity/blob/master/bradesco_token_aberto.sol";

// CONTRACT: 0x46BcD019e57CC2C07E5E41A050b90579484964BE

/*
    Contrato que representa uma custodia
*/
contract ExercicioCursoBlockchainTcc {

    Cliente private clienteEntidade;
    address private cliente;
    ExercicioToken private token;

    struct Cliente {
        string primeiroNome;
        string sobreNome;
        string agencia;
        string conta;
        address payable endereco; //0x0
        bool existe; //false
    }

    event EtherRecebido();

    constructor(
        string memory _primeiroNome,
        string memory _sobreNome,        
        string memory _agencia,
        string memory _conta,
        address _enderecoToken) payable {

        cliente = msg.sender;
        clienteEntidade = Cliente(_primeiroNome, _sobreNome, _agencia, _conta, payable(cliente), true);

        token = ExercicioToken(_enderecoToken);
    }

    function meuSaldo() public view returns(uint256) {
        //COMENTEI UMA POSSIVEL REGRA PARA PERMITIR QUE APENAS O CLIENTE CONSULTE O SALDO
        //require(msg.sender == cliente, "Somente o cliente pode consultar o saldo");
        return token.balanceOf(address(this));
    }

    function gerarTokenParaEuCliente(uint256 _amount) public returns (bool){
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

    function transfMoedaNativa(address _to, uint256 _amount) public payable {
        require(saldoAtualMoedaNativa() >= _amount, "Nao pode ser enviado valor maior que o saldo atual");
        (bool ok, ) = _to.call{value: _amount}(abi.encodeWithSignature("takeMoney()"));
        require(ok, "transfer failed");
    }

    receive() external payable {
        emit EtherRecebido();
    }
    
}
