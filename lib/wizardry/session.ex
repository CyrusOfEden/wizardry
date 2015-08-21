defmodule Wizardry.Session do
  import Plug.Conn

  @config Application.get_env(:wizardry, :config)
  @password_field Keyword.get(@config, :password_field)

  def login(conn, user) do
    fetch_session(conn) |> create_session(user)
  end

  def logout(conn) do
    fetch_session(conn) |> delete_session(:current_user)
  end

  def sanitize_user(user) do
    Map.drop(user, [@password_field, :__meta__, :__struct__])
  end

  defp create_session(conn, user) do
    put_session(conn, :current_user, sanitize_user(user))
  end
end