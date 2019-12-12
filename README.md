# Financial System [![CircleCI](https://circleci.com/gh/joaogularte/financial-system.svg?style=svg)](https://circleci.com/gh/joaogularte/financial-system)  [![Coverage Status](https://coveralls.io/repos/github/joaogularte/financial-system/badge.svg?branch=master)](https://coveralls.io/github/joaogularte/financial-system?branch=master)

Projeto desenvolvido com a linguagem de programação Elixir para o desafio da Stone Tech Challenge: https://github.com/stone-payments/tech-challenge 

## Sobre

O principal objetivo deste projeto é prover conjunto de ferramentas para realizar operações financeiras, tais como: débito, deposito, transferencia, split de transações e por fim câmbio entre valores monetários. Todas estas operações estão em compliance com a [ISO 4217](https://pt.wikipedia.org/wiki/ISO_4217). 

## Dependências

- [Elixir 1.9.4](https://github.com/elixir-lang/elixir)
- [Currencylayer:](https://currencylayer.com/) api utilizada para a busca, validataão e taxas das moedas em compliance com a ISO 4217.
- [Tesla:](https://github.com/teamon/tesla) Http Client para realizar as requisições HTTP
- [Poison:](https://github.com/devinus/poison) Json parser para realizer o decode da HTTP response
- [Decimal:](https://hexdocs.pm/decimal/readme.html) biblioteca decimal aritmética 

## Instalação

Para realizar a utilização do projeto primeiro é necessário fazer a instalação do Elixir.

Instalação para Ubuntu 14.04/16.04/17.04/18.04/19.04 ou Debian 7/8/9:
```
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && sudo dpkg -i erlang-solutions_2.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang
sudo apt-get install elixir

```
Instalação para macOS: https://elixir-lang.org/install.html#macos

Instalação para Windows: https://elixir-lang.org/install.html#windows

Instalação para demais distribuições: https://elixir-lang.org/install.html

Feito a instalação, é necessário que seja realizado o clone deste repositório com o seguinte comando: 
```
git clone  https://github.com/joaogularte/financial-system.git
```
Após isto e já na pasta do projeto basta instalar as dependências com:
```
mix deps.get
```

## Como usar 

Abra o terminal e rode o shell interativo do Elixir com o comando `iex -S mix`:
```
#criar contas de usuarios
account1 = FinancialSystem.create_account("Vitor Silva","vitor@gmail.com", "BRL", 500)
account2 = FinancialSystem.create_account("Breno Silva", "breno@gmail.com", "BRL", 500)
account3 = FinancialSystem.create_account("Bruno Costa", "bruno@gmail.com", "BRL", 500)

#depositar em uma conta, com e sem câmbio monetário
account1 = FinancialSystem.deposit(account1, "USD", 60)
account2 = FinancialSystem.deposit(account1, "BRL", 100)

#debitar de uma conta, com e sem câmbio monetário
account1 = FinancialSystem.debit(account1, "USD", 10)
account2 = FinancialSystem.debit(account2, "BRL", 20)

#transferir entre duas contas
%{from_account: from_account, to_account: to_account} = FinancialSystem.transfer(account1, account2, 20)

#split de transações entre usuarios
accounts_list = [%{to_account: account2, percentage: 70}, %{to_account: account3, percentage: 30}]
${accounts_list: accounts, from_account: from_account} = FinancialSystem.split(account1, accounts_list, 100)

#cambio entre valores monetarios
rate = FinancialSystem.exchange("BRL", "USD", 10)
```

## Testes



## Controle de Qualidade

* Integração Contínua - [CircleCI](https://circleci.com/gh/joaogularte/financial-system)
* Teste de cobertura - [ExCoveralls](https://coveralls.io/github/joaogularte/financial-system?branch=master)
