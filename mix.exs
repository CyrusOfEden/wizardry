defmodule Wizardry.Mixfile do
  use Mix.Project

  def project do
    [app: :wizardry,
     description: "Simple, low-level user account framework for Phoenix Framework",
     version: "0.1.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :comeonin]]
  end

  defp deps do
    [{:comeonin, "~> 1.1"}]
  end
end
