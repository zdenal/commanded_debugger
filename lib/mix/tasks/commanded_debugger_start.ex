defmodule Mix.Tasks.CommandedDebugger.Start do
  use Mix.Task

  @shortdoc "Simply calls the Hello.say/0 function."
  def run(_) do
    CommandedDebugger.start()
  end
end
