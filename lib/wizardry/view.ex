defmodule Wizardry.View do
  import Plug.Conn

  @session_key Application.get_env(:wizardry, :session_key)

  def logged_in?(conn) do
    !!current_user(conn)
  end

  def current_user(conn) do
    get_session(conn, @session_key)
  end
end