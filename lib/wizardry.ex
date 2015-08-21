defmodule Wizardry do
  import Plug.Conn

  alias Wizardry.Config

  def init(options) do
    options
  end

  def call(conn, options) do
    authenticate? = Keyword.get(options, :authenticate, false)

    fetch_session(conn)
    |> assign_param(Config.session_key)
    |> authenticate(Config.session_key, authenticate?)
  end

  def assign_param(conn, param) do
    case get_session(conn, param) do
      nil   -> conn
      value -> assign(conn, param, value)
    end
  end

  def authenticate(conn, _, false), do: conn
  def authenticate(conn, param, true) do
    if get_session(conn, param), do: conn, else: halt(conn)
  end
end
