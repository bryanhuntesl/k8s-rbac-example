defmodule Mix.Tasks.App.Name do
  use Mix.Task

  @shortdoc "Print out name of the application."
  def run(_) do
    Mix.Project.config[:app] |> IO.puts
  end
end
