defmodule CommandedDebugger.EventHandler do
  use Commanded.Event.Handler, name: "commanded_debugger_event_handler", start_from: :origin

  alias CommandedDebugger.{Buffer, EventAudit}

  def handle(event, metadata) do
    audit(event, metadata)
    |> Buffer.push()

    :ok
  end

  defp audit(event, metadata) do
    %EventAudit{
      uuid: metadata.event_id,
      causation_id: metadata.causation_id,
      correlation_id: metadata.correlation_id,
      created_at: metadata.created_at,
      type: Atom.to_string(event.__struct__),
      data: Map.from_struct(event) |> Jason.encode!(),
      metadata: metadata
    }
  end
end
