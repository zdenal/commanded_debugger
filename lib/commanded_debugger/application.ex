defmodule CommandedDebugger.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(type, _args) do
    # List all child processes to be supervised
    children =
      case type do
        :task ->
          [{CommandedDebugger.Buffer, []}]

        _ ->
          # CommandedDebugger.Buffer.node_address() |> Node.connect()
          [{CommandedDebugger.EventHandler, []}]
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CommandedDebugger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
