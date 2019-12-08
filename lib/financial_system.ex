defmodule FinancialSystem do
  @moduledoc """
  Documentation for FinancialSystem.
  """

  @doc """
  Create a new account
  ## Examples 
      FinancialSystem.create_account("Vitor Silva", "vitor@gmail.com", "BRL", 500)
      {:ok, %Account{ amount: 500, currency: "BRL", email: "vitor@gmail.com", name: "Vitor Silva" }}
  """
  @spec create_account(String.t(), String.t(), String.t(), number()) :: %Account{}
  def create_account(name, email, currency \\ "BRL", amount \\ 0) do
    if byte_size(name) > 0 &&
         byte_size(email) > 0 &&
         byte_size(currency) > 0 &&
         is_number(amount) do
      %Account{name: name, email: email, currency: currency, amount: amount}
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
  @spec has_funds?(%Account{name: String.t(), email: String.t(), amount: String.t()}, number()) ::
          boolean()
  def has_funds?(%Account{} = account, value) do
    account.amount >= value
  end
end
