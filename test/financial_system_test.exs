defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  setup do
    [
      account1:
        FinancialSystem.create_account("Carlos Eduardo Souza", "carlos@gmail", "BRL", 500),
      account2: FinancialSystem.create_account("João Ricardo Souza", "jr@gmail", "BRL", 100),
      account3: FinancialSystem.create_account("Ricardo Silva", "ricardo@gmail", "BRL", 200)
    ]
  end

  test "User should be able to create an account in any currency" do
    assert FinancialSystem.create_account("João Vitor", "joao@gmail.com", "BRL")
    assert FinancialSystem.create_account("Robson", "robson@gmail.com", "COP")
  end

  test "User should not be able to create an account with incorrect informations" do
    assert_raise ArgumentError, fn ->
      FinancialSystem.create_account("João Vitor", "joao@gmail.com", "BRL", "AAA")
    end
  end

  test "Check if account has funds", %{account1: account} do
    assert FinancialSystem.has_funds?(account, 200) == true
  end

  test "User should be able to deposit money into the account", %{account1: account} do
    assert FinancialSystem.deposit(account, "BRL", 50) == %Account{
             amount: Decimal.cast(550),
             currency: "BRL",
             email: "carlos@gmail",
             name: "Carlos Eduardo Souza"
           }
  end

  test "User should be able to deposit money into the foreign account", %{
    account1: account
  } do
    assert FinancialSystem.deposit(account, "USD", 50)
  end

  test "User should not be able to deposit money into the account with invalid currency", %{
    account1: account
  } do
    assert_raise ArgumentError, fn -> FinancialSystem.deposit(account, "AAA", 50) end
  end

  test "User should not be able to deposit negative values into the account", %{account1: account} do
    assert_raise FunctionClauseError, fn -> FinancialSystem.deposit(account, "BRL", -50) end
  end

  test "User should be able to debit money into the account", %{account1: account} do
    assert FinancialSystem.debit(account, "BRL", 50) == %Account{
             amount: Decimal.cast(450),
             currency: "BRL",
             email: "carlos@gmail",
             name: "Carlos Eduardo Souza"
           }
  end

  test "User should be able to debit money into the foreign account", %{
    account1: account
  } do
    assert FinancialSystem.debit(account, "USD", 15)
  end

  test "User should not be able to debit money into the account with insuficient funds", %{
    account1: account
  } do
    assert_raise RuntimeError, fn -> FinancialSystem.debit(account, "BRL", 600) end
  end

  test "User should not be able to debit money into the foreign account with insuficient funds",
       %{
         account1: account
       } do
    assert_raise RuntimeError, fn -> FinancialSystem.debit(account, "USD", 600) end
  end

  test "User should not be able to debit money into the account with invalid currency", %{
    account1: account
  } do
    assert_raise ArgumentError, fn -> FinancialSystem.debit(account, "AAA", 50) end
  end

  test "User should be able to transfer money to another account", %{
    account1: from_account,
    account2: to_account
  } do
    expect = %{
      from_account: %Account{
        amount: Decimal.cast(450),
        currency: "BRL",
        email: "carlos@gmail",
        name: "Carlos Eduardo Souza"
      },
      to_account: %Account{
        amount: Decimal.cast(150),
        currency: "BRL",
        email: "jr@gmail",
        name: "João Ricardo Souza"
      }
    }

    assert expect == FinancialSystem.transfer(from_account, to_account, 50)
  end

  test "User should not be able to transfer if not enough money avaiable on the account", %{
    account1: from_account,
    account2: to_account
  } do
    assert_raise RuntimeError, fn -> FinancialSystem.transfer(from_account, to_account, 600) end
  end

  test "A transfer should be cancelled if an error occurs", %{
    account1: from_account
  } do
    assert_raise FunctionClauseError, fn -> FinancialSystem.transfer(from_account, nil, 600) end
  end

  test "A transfer can be splitted between 2 or more accounts", %{
    account1: account1,
    account2: account2,
    account3: account3
  } do
    accounts_list = [
      %{to_account: account2, percentage: 50},
      %{to_account: account3, percentage: 50}
    ]

    assert FinancialSystem.split(account1, accounts_list, 200)
  end

  test "A transfer cannot be splitted if a wrong percentage was passed as parameter", %{
    account1: account1,
    account2: account2,
    account3: account3
  } do
    accounts_list = [
      %{to_account: account2, percentage: 60},
      %{to_account: account3, percentage: 50}
    ]

    assert_raise ArgumentError, fn -> FinancialSystem.split(account1, accounts_list, 200) end
  end

  test "User should be able to exchange money between two currencies" do
    assert FinancialSystem.exchange("BRL", "USD", 50)
  end

  test "User should not be able to exchange money between invalid currencies" do
    assert_raise ArgumentError, fn -> FinancialSystem.exchange("AAA", "USD", 50) end
  end
end
