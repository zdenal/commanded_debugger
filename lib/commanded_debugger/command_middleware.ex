defmodule CommandedDebugger.Middleware do
  @behaviour Commanded.Middleware

  alias CommandedDebugger.{CommandAudit, Buffer}
  alias Commanded.Middleware.Pipeline

  import Pipeline

  def before_dispatch(%Pipeline{} = pipeline) do
    pipeline
    |> assign(:start_time, monotonic_time())
    |> assign(:occurred_at, NaiveDateTime.utc_now())
    |> audit()
  end

  def after_dispatch(%Pipeline{} = pipeline), do: success(pipeline)

  def after_failure(%Pipeline{} = pipeline), do: failure(pipeline)

  defp audit(%Pipeline{} = pipeline) do
    %Pipeline{
      assigns: %{occurred_at: occurred_at},
      causation_id: causation_id,
      correlation_id: correlation_id,
      command: command,
      command_uuid: command_uuid,
      metadata: metadata
    } = pipeline

    audit = %CommandAudit{
      uuid: command_uuid,
      causation_id: causation_id,
      correlation_id: correlation_id,
      occurred_at: occurred_at,
      type: Atom.to_string(command.__struct__),
      data: Map.from_struct(command) |> Jason.encode!(),
      metadata: metadata
    }

    Buffer.push(audit)

    pipeline
  end

  defp success(%Pipeline{} = pipeline) do
    %Pipeline{command_uuid: command_uuid} = pipeline

    Buffer.update(command_uuid, %{success: true, execution_duration_usecs: delta(pipeline)})

    pipeline
  end

  defp failure(%Pipeline{} = pipeline) do
    %Pipeline{command_uuid: command_uuid} = pipeline

    command_uuid
    |> Buffer.update(%{
      success: false,
      execution_duration_usecs: delta(pipeline),
      error: extract(pipeline, :error),
      error_reason: extract(pipeline, :error_reason)
    })

    pipeline
  end

  defp extract(%Pipeline{assigns: assigns}, key) do
    case Map.get(assigns, key) do
      nil -> nil
      value -> inspect(value)
    end
  end

  defp monotonic_time, do: System.monotonic_time(:microsecond)

  # Calculate the delta, in microseconds, between command start and end time (now)
  defp delta(%Pipeline{assigns: %{start_time: start_time}}) do
    end_time = monotonic_time()

    end_time - start_time
  end

  defp delta(%Pipeline{}), do: nil
end
