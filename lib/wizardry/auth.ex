defmodule Wizardry.Auth do
  alias Comeonin.Password
  alias Wizardry.Config

  # API
  def hash(password) do
    Config.derivation.hashpwsalt(password)
  end

  def check(password, hash) do
    Config.derivation.checkpw(password, hash)
  end

  def strong_password?(password) do
    Password.strong_password?(password, Config.password_options)
  end

  def generate_password(length \\ 12) do
    Password.gen_password(length)
  end

  def process(params, check \\ true)
  def process(params = %{"password" => password}, check) do
    params
    |> Map.delete("password")
    |> process_map(password, Atom.to_string(Config.password_field), check)
  end
  def process(params = %{password: password}, check) do
    params
    |> Map.delete(:password)
    |> process_map(password, Config.password_field, check)
  end
  def process(_, _) do
    {:error, "no password found"}
  end

  def verify(nil, _), do: {:error, "no user"}
  def verify(_, nil), do: {:error, "no password"}
  def verify(user, password) when is_map(user) and is_binary(password) do
    case check(password, Map.get(user, Config.password_field)) do
      true  -> {:ok, user}
      false -> {:error, "incorrect password"}
    end
  end

  defp process_map(params, password, field, false) do
    {:ok, Map.put_new(params, field, hash(password))}
  end
  defp process_map(params, password, field, true) do
    case strong_password?(password) do
      true    -> process_map(params, password, field, false)
      message -> {:error, message}
    end
  end
end