defmodule Account do
  @moduledoc """
  Declare main fields to account entity
  """
  @enforce_keys [:name, :email]
  defstruct name: "", email: "", currency: "BRL", amount: 0

  @type t :: %Account{
          name: String.t(),
          email: String.t(),
          currency: String.t(),
          amount: number
        }
end
