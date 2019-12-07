defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  test "greets the world" do
    assert FinancialSystem.hello() == :world
  end

  test "create an account" do
    assert FinancialSystem.create_account("João Vitor", "joao@gmail.com", "BR") 
  end
end
