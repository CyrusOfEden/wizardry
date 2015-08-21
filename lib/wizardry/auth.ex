defmodule Wizardry.Auth do
  alias Comeonin.Password

  # Config
  @config Application.get_env(:wizardry, :config)

  @algorithm Keyword.get(@config, :hashing_algorithm)
  @password_field Keyword.get(@config, :password_field)
  @password_strength_options Keyword.get(@config, :password_strength_options)

  @derivation Module.concat(Comeonin, String.capitalize(Atom.to_string(@algorithm)))

  # API
  def hash(password) do
    @derivation.hashpwsalt(password)
  end

  def check(password, hash) do
    @derivation.checkpw(password, hash)
  end

  def strong_password?(password) do
    Password.strong_password?(password, @password_strength_options)
  end

  def generate_password(length \\ 12) do
    Password.gen_password(length)
  end

  def process(params, check \\ true)
  def process(params = %{"password" => password}, check) do
    params
    |> Map.delete("password")
    |> process_map(password, Atom.to_string(@password_field), check)
  end
  def process(params = %{password: password}, check) do
    params
    |> Map.delete(:password)
    |> process_map(password, @password_field, check)
  end
  def process(_, _) do
    {:error, "no password found"}
  end

  def verify(nil, _), do: {:error, "no user"}
  def verify(_, nil), do: {:error, "no password"}
  def verify(user, password) when is_map(user) and is_binary(password) do
    case check(password, Map.get(user, @password_field)) do
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