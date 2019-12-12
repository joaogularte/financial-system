defmodule Currency do
  @moduledoc """
  Currency module has validation, verification and rating about currencies in compliance with ISO4217. 
  Currencylayer API(https://currencylayer.com/) is consult in order to get informations about currency and rate.
  """
  use Agent
  use Tesla
  plug(Tesla.Middleware.BaseUrl, "http://www.apilayer.net/api")

  @access_key "6da65783efc74e33a63a6fbd64f56487"

  @doc """
  Get list of currencies in complience with ISO 4217 through Currencylayer API
  ## Examples 
      Currency.list()
  """
  @spec list() :: map() | RuntimeError
  def list() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)

    case do_list() do
      :ok -> Agent.get(__MODULE__, fn state -> state end)
      {:error} -> raise "unable to get currency list from the server"
    end
  end

  @spec do_list() :: map() | {:error}
  defp do_list() do
    case get("/list?access_key=#{@access_key}") do
      {:ok, response} ->
        Agent.update(__MODULE__, fn _state -> Poison.decode!(response.body)["currencies"] end)

      _error ->
        {:error}
    end
  end

  @doc """
  Get currencies rates through Currencylayer API
  ## Examples
      Currency.rate()
  """
  @spec rate() :: map() | RuntimeError
  def rate() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)

    case do_rate() do
      :ok -> Agent.get(__MODULE__, fn state -> state end)
      {:error} -> raise "unable to get currency rate from the server"
    end
  end

  @spec do_rate() :: map() | {:error}
  defp do_rate() do
    case get("/live?access_key=#{@access_key}&format=1") do
      {:ok, response} ->
        Agent.update(__MODULE__, fn _state -> Poison.decode!(response.body)["quotes"] end)

      _error ->
        {:error}
    end
  end

  @doc """
  Check if currency is valid
  ## Examples
      Currency.valid?("BRL") 
  """
  @spec valid?(String.t()) :: boolean()
  def valid?(currency) when byte_size(currency) > 0 do
    list() |> Map.has_key?(currency)
  end
end
