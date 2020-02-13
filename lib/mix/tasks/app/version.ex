defmodule Mix.Tasks.App.Version do
  use Mix.Task

  @shortdoc "Print out current version of the application."
  def run(_) do
    Mix.Project.config[:version] |> IO.puts
  end
end
