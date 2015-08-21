defmodule Wizardry.View do
  import Plug.Conn

  @config Application.get_env(:wizardry, :config)
  @session_key Keyword.get(@config, :session_key)

  def logged_in?(conn) do
    !!current_user(conn)
  end

  def current_user(conn) do
    get_session(conn, @session_key)
  end
end