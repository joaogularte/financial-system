defmodule Account do
  @moduledoc """

  """
  @enforce_keys [:name, :email]
  defstruct name: "", email: "", currency: "BR", amount: 0
  
  @doc """
  
  """
  def create(name, email, currency \\ "BR", amount \\ 0) do
    if byte_size(name) > 0 &&
         byte_size(email) > 0 &&
         byte_size(currency) > 0 &&
         is_number(amount) do
      {:ok, %Account{name: name, email: email, currency: currency, amount: 0}}
    else
      raise ArgumentError, message: "the argument value is invalid"
    end
  end
end
