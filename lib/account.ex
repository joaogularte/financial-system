defmodule Account do
  @moduledoc """
  
  """
  @enforce_keys [:name, :email, :currency]
  defstruct name: "", email: "", currency: "BR", amount: 0
end
