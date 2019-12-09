defmodule FinancialSystemTest do
  use ExUnit.Case, async: true
  doctest FinancialSystem

  setup do
    [
      account1:
        FinancialSystem.create_account("Carlos Eduardo Souza", "carlos@gmail", "BRL", 500),
      account2: FinancialSystem.create_account("João Ricardo Souza", "jr@gmail", "BRL", 100)
    ]
  end

  test "Create an account" do
    assert FinancialSystem.create_account("João Vitor", "joao@gmail.com", "BRL")
  end

  test "Check if account has funds", %{account1: account} do
    assert FinancialSystem.has_funds?(account, 200) == true
  end

  test "User should be able to deposit money into the account", %{account1: account} do
    assert FinancialSystem.deposit(account, 50) == %Account{
             amount: 550,
             currency: "BRL",
             email: "carlos@gmail",
             name: "Carlos Eduardo Souza"
           }
  end

  test "User should be able to debit money into the account", %{account1: account} do
    assert FinancialSystem.debit(account, 50) == %Account{
             amount: 450,
             currency: "BRL",
             email: "carlos@gmail",
             name: "Carlos Eduardo Souza"
           }
  end

  test "User should not be able to debit money into the account with insuficient funds", %{
    account1: account
  } do
    assert_raise RuntimeError, fn -> FinancialSystem.debit(account, 501) end
  end

  test "User should be able to transfer money to another account", %{
    account1: from_account,
    account2: to_account
  } do
    expect = %{
      from_account: %Account{
        amount: 450,
        currency: "BRL",
        email: "carlos@gmail",
        name: "Carlos Eduardo Souza"
      },
      to_account: %Account{
        amount: 150,
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
end
