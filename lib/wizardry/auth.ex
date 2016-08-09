defmodule Wizardry.Auth do
  alias Wizardry.Config

  # API
  def hash(password) do
    Config.derivation.hashpwsalt(password)
  end

  def check(password, hash) do
    Config.derivation.checkpw(password, hash)
  end

  def process(params = %{"password" => password}) do
    params
    |> Map.delete("password")
    |> process_map(password, Atom.to_string(Config.password_field))
  end
  def process(params = %{password: password}) do
    params
    |> Map.delete(:password)
    |> process_map(password, Config.password_field)
  end
  def process(_) do
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

  defp process_map(params, password, field) do
    {:ok, Map.put_new(params, field, hash(password))}
  end
end
