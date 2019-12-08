defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  setup do
    account = FinancialSystem.create_account("Carlos Eduardo Souza", "carlos@gmail", "BRL", 500)

    %{account: account}
  end

  test "create an account" do
    assert FinancialSystem.create_account("João Vitor", "joao@gmail.com", "BRL")
  end

  test "check if account has funds", %{account: account} do
    assert FinancialSystem.has_funds?(account, 200) == true
  end
end
