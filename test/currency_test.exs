defmodule CurrencyTest do
  use ExUnit.Case, async: true
  doctest Currency

  test "Get currency list in complience with ISO 4217 from server" do
    assert Currency.currency_list()
  end

  test "Get currency rate from server" do
    assert Currency.rate()
  end
end
