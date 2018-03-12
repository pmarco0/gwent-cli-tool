defmodule Gwent.MixProject do
  use Mix.Project

  def project do
    [
      app: :gwent,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  def escript do
    [applications: [:httpotion], main_module: Gwent.CLI]
  end


  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, "~> 3.1.0"},
      {:poison, "~> 3.1"},
    ]
  end
end
