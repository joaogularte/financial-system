defmodule Account do
  @moduledoc """
  Declare main fields to account entity
  """
  @enforce_keys [:name, :email]
  defstruct name: "", email: "", currency: "BR", amount: 0
end
