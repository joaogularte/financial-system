defmodule FinancialSystemTest do
  use ExUnit.Case, async: true
  doctest FinancialSystem

  setup do
    account = FinancialSystem.create_account("Carlos Eduardo Souza", "carlos@gmail", "BRL", 500)

    %{account: account}
  end

  test "Create an account" do
    assert FinancialSystem.create_account("João Vitor", "joao@gmail.com", "BRL")
  end

  test "Check if account has funds", %{account: account} do
    assert FinancialSystem.has_funds?(account, 200) == true
  end

  test "User should be able to deposit money into the account", %{account: account} do
    assert FinancialSystem.deposit(account, 50) == %Account{
             amount: 550,
             currency: "BRL",
             email: "carlos@gmail",
             name: "Carlos Eduardo Souza"
           }
  end

  test "User should be able to debit money into the account", %{account: account} do
    assert FinancialSystem.debit(account, 50) == %Account{
             amount: 450,
             currency: "BRL",
             email: "carlos@gmail",
             name: "Carlos Eduardo Souza"
           }
  end

  test "User should not be able to debit money into the account with insuficient funds", %{
    account: account
  } do
    assert_raise RuntimeError, fn -> FinancialSystem.debit(account, 501) end
  end
end
