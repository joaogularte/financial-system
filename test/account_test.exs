defmodule AccountTest do
  use ExUnit.Case, async: true

  doctest Account

  test "create a account" do
    assert Account.create("Joao Vitor Gularte", "joao@gmail.com", "BR", 12)
  end 
end