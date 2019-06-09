defmodule CommandedDebugger.Utils.View do
  alias CommandedDebugger.{EventAudit, CommandAudit}

  def display(data) do
    Jason.decode!(data) |> Jason.encode!(pretty: true)
  end

  def title(%CommandAudit{type: type}), do: type |> String.replace("Elixir.", "[Com] ")
  def title(%EventAudit{type: type}), do: type |> String.replace("Elixir.", "[Evt] ")
  def title(nil), do: "Nothing selected"

  def header do
    "Commanded Debugger (UP/DOWN to select command/event, j/k to scroll content, r to reset buffer). Node: #{
      Node.self()
    }"
  end

  def display_created_at(%CommandAudit{occurred_at: t}) do
    time = [t.hour, t.minute, t.second] |> Enum.map(&pad_with_zero/1)
    date = [t.year, t.month, t.day] |> Enum.map(&pad_with_zero/1)
    Enum.join(time, ":") <> " " <> Enum.join(date, "/")
  end

  def display_created_at(%EventAudit{created_at: t}) do
    time = [t.hour, t.minute, t.second] |> Enum.map(&pad_with_zero/1)
    date = [t.year, t.month, t.day] |> Enum.map(&pad_with_zero/1)
    Enum.join(time, ":") <> " " <> Enum.join(date, "/")
  end

  def pad_with_zero(t), do: to_string(t) |> String.pad_leading(2, "0")
end
