defmodule Wizardry do
  import Plug.Conn

  @session_key Application.get_env(:wizardry, :session_key)

  def init(options), do: options

  def call(conn, options) do
    conn = fetch_session(conn)

    conn
    |> assign_param(@session_key)
    |> authenticate(@session_key, opts[:authenticate])
  end

  defp assign_param(conn, param) do
    case get_session(conn, param) do
      nil   -> conn
      value -> assign(conn, param, user)
    end
  end

  defp authenticate(conn, _, false), do: conn
  defp authenticate(conn, param, true) do
    if get_session(conn, param), do: conn, else: halt(conn)
  end
end
