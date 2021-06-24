defmodule RTP.MixProject do
  use Mix.Project

  def project do
    [
      app: :rtp,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :mediator],
      mod: {RTP, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:eventsource_ex, git: "git://github.com/cwc/eventsource_ex.git"},
      {:mongodb_driver, git: "git://github.com/zookzook/elixir-mongodb-driver.git"},
      {:json, "~> 1.4"},
      {:poison, "~> 3.1"},
      {:mediator, in_umbrella: true}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
