defmodule Currency do
  @moduledoc """

  """
  use Agent
  plug(Tesla.Middleware.BaseUrl, "http://www.apilayer.net/api")
  plug(Tesla.Middleware.JSON)
  @access_key "272f531700cf18dcafcc40fd74b3559e"
end
