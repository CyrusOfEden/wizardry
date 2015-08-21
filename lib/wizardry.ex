defmodule Wizardry do
  import Plug.Conn

  alias Wizardry.Config

  def init(options), do: options

  def call(conn, options) do
    conn = fetch_session(conn)

    conn
    |> assign_param(Config.session_key)
    |> authenticate(Config.session_key, options[:authenticate])
  end

  defp assign_param(conn, param) do
    case get_session(conn, param) do
      nil   -> conn
      value -> assign(conn, param, value)
    end
  end

  defp authenticate(conn, _, false), do: conn
  defp authenticate(conn, param, true) do
    if get_session(conn, param), do: conn, else: halt(conn)
  end
end
