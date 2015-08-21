defmodule Wizardry.View do
  import Plug.Conn

  alias Wizardry.Config

  def logged_in?(conn) do
    !!current_user(conn)
  end

  def current_user(conn) do
    get_session(conn, Config.session_key)
  end
end