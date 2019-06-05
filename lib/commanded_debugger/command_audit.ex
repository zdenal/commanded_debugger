defmodule CommandedDebugger.CommandAudit do
  defstruct [
    :uuid,
    :causation_id,
    :correlation_id,
    :occurred_at,
    :type,
    :data,
    :metadata,
    :callback_data
  ]
end
