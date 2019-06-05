defmodule CommandedDebugger do
  def start do
    Ratatouille.run(CommandedDebugger.Debugger)
  end
end
