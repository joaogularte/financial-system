defmodule CurrencyTest do
  use ExUnit.Case
  doctest Currency

  test "Currency should be in complience with ISO 4217 from server" do
    assert Currency.list()
  end

  test "Currency should be to get currency rate from server" do
    assert Currency.rate()
  end

  test "Check if currency is in compliance with ISO 4217" do
    assert Currency.valid?("SEK") == true
    assert Currency.valid?("VNT") == false
  end
end
