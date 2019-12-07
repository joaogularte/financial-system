defmodule FinancialSystem do
  @moduledoc """
  Documentation for FinancialSystem.
  """

  @doc """
  Hello world.

  ## Examples

      iex> FinancialSystem.hello()
      :world

  """
  def hello do
    :world
  end


  @doc """
  Create a new account
  ## Examples 
  """
  def create_account(name, email, currency \\ "BR", amount \\ 0) do
    if byte_size(name) > 0 &&
         byte_size(email) > 0 &&
         byte_size(currency) > 0 &&
         is_number(amount) do
      {:ok, %Account{name: name, email: email, currency: currency, amount: 0}}
    else
      raise ArgumentError, message: "the argument value is invalid"
    end
  end

  @doc """
  Check if an account has funds enough 
  ## Examples
  """
  def has_funds?(%Account{} = account, value) do
    account.amount >= value
  end
end
