defmodule Account do
  @moduledoc """
  Define main fields to account entity
  """
  @enforce_keys [:name, :email]
  defstruct name: "", email: "", currency: "BR", amount: 0
end
