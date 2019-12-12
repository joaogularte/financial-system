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
    with true <- byte_size(name) > 0,
         true <- byte_size(email) > 0,
         true <- Currency.valid?(currency),
         true <- is_number(amount) do
      %Account{
        name: name,
        email: email,
        currency: String.upcase(currency),
        amount: Decimal.cast(amount)
      }
    else
      _error -> raise(ArgumentError, message: "the argument value is invalid")
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
    Enum.member?([:gt, :eq], Decimal.cmp(account.amount, value))
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
  @spec deposit(Account.t(), String.t(), number()) :: Account.t() | ArgumentError
  def deposit(%Account{} = account, currency, value)
      when is_positive(value) and byte_size(currency) > 0 do
    if Currency.valid?(currency) do
      do_deposit(account, account.currency == currency, currency, value)
    else
      raise(ArgumentError, message: "currency invalid")
    end
  end

  @spec do_deposit(Account.t(), true, String.t(), number()) :: Account.t()
  defp do_deposit(%Account{} = account, same_currency = true, currency, value) do
    amount = Decimal.add(account.amount, Decimal.cast(value))
    %{account | amount: amount}
  end

  @spec do_deposit(Account.t(), false, String.t(), number()) :: Account.t()
  defp do_deposit(%Account{} = account, same_currency = false, currency, value) do
    amount =
      exchange(currency, account.currency, value)
      |> Decimal.add(account.amount)

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
    amount = Decimal.sub(account.amount, value)
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
    deposited_account = deposit(to_account, "BRL", value)
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
          ratio =
            value
            |> Decimal.cast()
            |> Decimal.mult(account[:percentage])
            |> Decimal.div(100)
            |> Decimal.round(2)
            |> Decimal.to_float()

          deposit(account[:to_account], "BRL", ratio)
        end
      )

    %{from_account: debited_account, accounts_list: deposited_accounts}
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
      Decimal.add(account[:percentage], total_percent)
    end)
    |> Decimal.equal?(100)
  end

  @doc """
  Exchanging between two different currencies 
  ## Example
      FinancialSystem.exchange("BRL", "USD", 10)
  """
  @spec exchange(String.t(), String.t(), number()) :: number() | ArgumentError
  def exchange(from_currency, to_currency, value)
      when is_positive(value) and byte_size(from_currency) > 0 and byte_size(to_currency) > 0 do
    cond do
      Currency.valid?(from_currency) == false -> raise ArgumentError, "from_currency is invalid"
      Currency.valid?(to_currency) == false -> raise ArgumentError, "to_currency is invalid"
      from_currency == to_currency -> raise ArgumentError, "from_currency is equal to to_currency"
      true -> Currency.rate() |> do_exchange(from_currency, to_currency, value)
    end
  end

  @spec do_exchange(list(), String.t(), String.t(), number()) :: number()
  defp do_exchange(rates, from_currency, to_currency, value) do
    value
    |> Decimal.cast()
    |> Decimal.div(Decimal.cast(rates["USD#{from_currency}"]))
    |> Decimal.mult(Decimal.cast(rates["USD#{to_currency}"]))
    |> Decimal.round(2)
  end
end
