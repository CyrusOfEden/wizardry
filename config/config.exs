use Mix.Config

config :wizardry, :config,
  session_key: :current_user,
  hashing_algorithm: :pbkdf2,
  password_field: :password_hash,
  password_strength_options: []
