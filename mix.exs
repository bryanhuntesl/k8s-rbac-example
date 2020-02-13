defmodule PodViewer.MixProject do
  use Mix.Project

  def project do
    [
      app: :pod_viewer,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        pod_viewer: [
          steps: [:assemble, :tar]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PodViewer, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.1"},
      {:k8s, "~> 0.5"},
      {:jason, "~> 1.1"}
    ]
  end
end
