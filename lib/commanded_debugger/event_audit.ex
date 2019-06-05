defmodule CommandedDebugger.EventAudit do
  defstruct [
    :uuid,
    :causation_id,
    :correlation_id,
    :created_at,
    :event_type,
    :data,
    :metadata
  ]
end
