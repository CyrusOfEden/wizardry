defmodule Wizardry.Config do
  @config Keyword.merge([session_key: :current_user,
                         hashing_algorithm: :pbkdf2,
                         password_field: :password_hash,
                         password_strength_options: []],
                         Application.get_env(:wizardry, :config) || [])

  def config, do: @config
  def algorithm, do: Keyword.get(@config, :hashing_algorithm)
  def session_key, do: Keyword.get(@config, :session_key)
  def password_field, do: Keyword.get(@config, :password_field)
  def password_options, do: Keyword.get(@config, :password_strength_options)

  def derivation do
    Module.concat(Comeonin, String.capitalize(Atom.to_string(algorithm)))
  end
end