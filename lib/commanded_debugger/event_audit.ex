defmodule CommandedDebugger.EventAudit do
  defstruct [
    :uuid,
    :causation_id,
    :correlation_id,
    :created_at,
    :type,
    :data,
    :metadata
  ]
end
