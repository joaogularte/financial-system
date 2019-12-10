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
      raise(ArgumentError, message: "the argument value is invalid")
    end
  end

  @doc """
  Check if the account has funds enough 
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

  @spec is_positive(number()) :: boolean()
  defguardp is_positive(value) when is_number(value) and value > 0

  @doc """
  Make a deposit into the account
  ## Examples
      account = FinancialSystem.create_account("Marcelo Souza", "marcelo@gmail.com", "BRL", 100)
      %Account{ amount: 100, currency: "BRL", email: "marcelo@gmail.com", name: "Marcelo Souza" }
      FinancialSystem.deposit(account, 60)
      %Account{ amount: 160, currency: "BRL", email: "marcelo@gmail.com", name: "Marcelo Souza" }
  """
  @spec deposit(Account.t(), number()) :: Account.t()
  def deposit(%Account{} = account, value) when is_positive(value) do
    do_deposit(account, value)
  end

  @spec do_deposit(Account.t(), number()) :: Account.t()
  defp do_deposit(%Account{} = account, value) do
    amount = account.amount + value
    %{account | amount: amount}
  end

  @doc """
  Make a debit into the account
  ## Examples
      account = FinancialSystem.create_account("Marcelo Souza", "marcelo@gmail.com", "BRL", 100)
      %Account{ amount: 100, currency: "BRL", email: "marcelo@gmail.com", name: "Marcelo Souza" }
      FinancialSystem.debit(account, 60)
      %Account{ amount: 40, currency: "BRL", email: "marcelo@gmail.com", name: "Marcelo Souza" }
  """
  @spec debit(Account.t(), number()) :: Account.t()
  def debit(%Account{} = account, value) when is_positive(value) do
    if has_funds?(account, value) do
      do_debit(account, value)
    else
      raise "account with insuficient funds"
    end
  end

  @spec do_debit(Account.t(), number()) :: Account.t()
  defp do_debit(%Account{} = account, value) do
    amount = account.amount - value
    %{account | amount: amount}
  end

  @doc """
  Make money transfer between two accounts
  ## Examples
      account1 = FinancialSystem.create_account("Marcelo Souza", "marcelo@gmail.com", "BRL", 100)
      account2 = FinancialSystem.create_account("Pedro Souza", "pedro@gmail.com", "BRL", 100)

      FinancialSystem.transfer(account1, account2, 50)
      %{from_account:  %Account{ amount: 50, currency: "BRL", email: "marcelo@gmail.com", name: "Marcelo Souza" },
      to_account:  %Account{ amount: 150, currency: "BRL", email: "pedro@gmail.com", name: "Pedro Souza" }}
  """
  @spec transfer(Account.t(), Account.t(), number()) :: %{
          from_account: Account.t(),
          to_account: Account.t()
        }
  def transfer(%Account{} = from_account, %Account{} = to_account, value)
      when is_positive(value) do
    debited_account = debit(from_account, value)
    deposited_account = deposit(to_account, value)
    %{from_account: debited_account, to_account: deposited_account}
  end

  @doc """
  Split money between accounts given percentage
  ## Examples
      account1 = FinancialSystem.create_account("Marcelo Souza", "marcelo@gmail.com", "BRL", 200)
      account2 = FinancialSystem.create_account("Pedro Souza", "pedro@gmail.com", "BRL", 100)
      account3 = FinancialSystem.create_account("Denis Souza", "denis@gmail.com", "BRL", 300)
      
      accounts_list = [%{to_account: account2, percentage: 70}, %{to_account: account3, percentage: 30}]
      FinancialSystem.split(account1, accounts_list, 100)
      %{accounts_list: [ %Account{ amount: 170, currency: "BRL", email: "pedro@gmail.com", name: "Pedro Souza" },
          %Account{ amount: 330, currency: "BRL", email: "denis@gmail.com", name: "Denis Souza"} ],
        from_account: %Account{ amount: 100, currency: "BRL", email: "marcelo@gmail.com",name: "Marcelo Souza"} }
  """
  @spec split(Account.t(), list(), number()) :: %{
          from_account: Account.t(),
          accounts_list: list()
        }
  def split(%Account{} = from_account, accounts_list, value)
      when is_positive(value) and is_list(accounts_list) do
    if complete_percentage?(accounts_list) do
      do_split(from_account, accounts_list, value)
    else
      raise(ArgumentError, message: "accounts with percentage incorrect")
    end
  end

  @spec do_split(Account.t(), list(), number()) :: %{
          from_account: Account.t(),
          accounts_list: list()
        }
  defp do_split(%Account{} = from_account, accounts_list, value) do
    debited_account = debit(from_account, value)

    deposited_accounts =
      Enum.map(
        accounts_list,
        fn account ->
          amount = percent_number(value, account[:percentage])
          deposit(account[:to_account], amount)
        end
      )

    %{from_account: debited_account, accounts_list: deposited_accounts}
  end

  @spec percent_number(number(), number()) :: number()
  defp percent_number(number, percent) when is_positive(number) and is_positive(percent) do
    div(number * percent, 100)
  end

  @doc """
  Check if the sum of accounts percentage list is equal 100
  ## Examples
      account1 = FinancialSystem.create_account("Marcelo Souza", "marcelo@gmail.com", "BRL", 200)
      account2 = FinancialSystem.create_account("Pedro Souza", "pedro@gmail.com", "BRL", 100)

      accounts_list = [%{to_account: account1, percentage: 70}, %{to_account: account2, percentage: 30}]
      FinancialSystem.complete_percentage?(accouns_list)
      true
  """
  @spec complete_percentage?(list()) :: boolean()
  def complete_percentage?(accounts_list) when is_list(accounts_list) do
    Enum.reduce(accounts_list, 0, fn account, total_percent ->
      account[:percentage] + total_percent
    end) == 100
  end
end
