defmodule EasyPostTrackers.MixProject do
  use Mix.Project

  def project do
    [
      app: :easy_post_trackers,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {EasyPostTrackers.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:req, "~> 0.3"},
      {:floki, "~> 0.34"},
      {:plug, "~> 1.14"},
      {:plug_cowboy, "~> 2.6"}
    ]
  end
end
