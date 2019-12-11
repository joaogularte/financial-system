defmodule Currency do
  @moduledoc """

  """
  use Agent
  use Tesla
  plug(Tesla.Middleware.BaseUrl, "http://www.apilayer.net/api")
  
  @access_key "272f531700cf18dcafcc40fd74b3559e"

  @doc """
  Get list of currencies in complience with ISO 4217 through Currencylayer API
  ## Examples 
      Currency.list()
  """
  @spec list() :: map()
  def list() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)

    case do_list() do
        :ok -> Agent.get(__MODULE__, fn state -> state end)
        {:error} -> raise "Unable to get currency list from the server"
    end 
  end
  @spec do_list() :: map()
  defp do_list() do
    case get("/list?access_key=#{@access_key}") do
      {:ok, response} ->
        Agent.update(__MODULE__, fn state -> Poison.decode!(response.body)["currencies"] end)

      _error ->
        {:error}
    end
  end
    end
  end
end
