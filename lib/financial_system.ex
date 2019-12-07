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
      FinancialSystem.create_account("Vitor Silva", "vitor@gmail.com", "BRL", 500)
      {:ok, %Account{ amount: 500, currency: "BRL", email: "vitor@gmail.com", name: "Vitor Silva" }}
  """
  def create_account(name, email, currency \\ "BRL", amount \\ 0) do
    if byte_size(name) > 0 &&
         byte_size(email) > 0 &&
         byte_size(currency) > 0 &&
         is_number(amount) do
      {:ok, %Account{name: name, email: email, currency: currency, amount: amount}}
    else
      raise ArgumentError, message: "the argument value is invalid"
    end
  end

  @doc """
  Check if an account has funds enough 
  ## Examples
      {:ok, account} = FinancialSystem.create_account("Vitor Silva", "vitor@gmail.com", "BRL", 500)
      {:ok, %Account{ amount: 500, currency: "BRL", email: "vitor@gmail.com", name: "Vitor Silva" }}

      FinancialSystem.has_funds?(account, 450)
      true 
  """
  def has_funds?(%Account{} = account, value) do
    account.amount >= value
  end
end
