defmodule CommandedDebugger.Utils.Tree do
  import Ratatouille.View
  import Ratatouille.Constants, only: [color: 1]

  alias CommandedDebugger.{EventAudit, CommandAudit}

  defmodule Node do
    defstruct [:uuid, :content, :parent_uuid, :data, :min_datetime, children: []]
  end

  def correlation_trees(buffer) do
    for {{correlation_id, items}, idx} <-
          group_by(buffer, :correlation_id) |> Enum.with_index() do
      %Node{
        uuid: idx,
        parent_uuid: nil,
        content: "[Cor] " <> correlation_id,
        children: correlation_tree(items, idx)
      }
      |> add_min_datetime()
    end
    |> Enum.sort_by(fn node -> node.min_datetime end, &<=/2)
  end

  def move_cursor([], [], _direction), do: []

  def move_cursor([h | _], [], _direction) do
    [h]
  end

  def move_cursor(trees, [current_node | tail] = cursor, :down) do
    if Enum.empty?(current_node.children) do
      next_in_parent(trees, tail, current_node)
    else
      [List.first(current_node.children) | cursor]
    end
  end

  def move_cursor(trees, [current_node | tail] = cursor, :up) do
    prev_in_parent(trees, tail, current_node)
  end

  defp min_children_time(%Node{children: []} = node), do: children_time(node)

  defp min_children_time(%Node{children: children}) do
    Enum.map(children, &children_time/1) |> Enum.min()
  end

  defp children_time(%Node{children: [], data: data}), do: children_time(data)
  defp children_time(%Node{min_datetime: t}), do: t
  defp children_time(%CommandAudit{occurred_at: t}), do: time_to_string(t)
  defp children_time(%EventAudit{created_at: t}), do: time_to_string(t)

  defp time_to_string(%NaiveDateTime{} = t), do: NaiveDateTime.to_iso8601(t)
  defp time_to_string(%DateTime{} = t), do: DateTime.to_iso8601(t)
  defp time_to_string(t), do: t

  defp prev_in_parent(trees, [], current_node) do
    idx = Enum.find_index(trees, fn t -> t.uuid == current_node.uuid end)

    if idx == 0, do: [List.last(trees)], else: [Enum.at(trees, idx - 1)]
  end

  defp prev_in_parent(trees, [parent | tail] = cursor, current_node) do
    idx = Enum.find_index(parent.children, fn t -> t.uuid == current_node.uuid end)

    if idx == 0,
      do: cursor,
      else: [Enum.at(parent.children, idx - 1) | cursor]
  end

  defp next_in_parent(trees, [], current_node) do
    idx = Enum.find_index(trees, fn t -> t.uuid == current_node.uuid end)
    size = length(trees)

    if idx + 1 == size, do: [List.first(trees)], else: [Enum.at(trees, idx + 1)]
  end

  defp next_in_parent(trees, [parent | tail] = cursor, current_node) do
    idx = Enum.find_index(parent.children, fn t -> t.uuid == current_node.uuid end)
    size = length(parent.children)

    if idx + 1 == size,
      do: next_in_parent(trees, tail, parent),
      else: [Enum.at(parent.children, idx + 1) | cursor]
  end

  defp group_by(items, key) do
    items |> Enum.group_by(fn i -> Map.get(i, key) end)
  end

  defp correlation_tree(items, parent_uuid) do
    roots = get_roots(items)

    Enum.map(roots, fn root ->
      %Node{
        uuid: root.uuid,
        parent_uuid: parent_uuid,
        data: root,
        content: content(root),
        children: get_children(root, items)
      }
      |> add_min_datetime()
    end)
    |> Enum.sort_by(fn node -> node.min_datetime end, &<=/2)
  end

  defp get_children(root, items) do
    children = Enum.filter(items, fn i -> i.causation_id == root.uuid end)

    Enum.map(children, fn ch ->
      %Node{
        uuid: ch.uuid,
        parent_uuid: root.uuid,
        content: content(ch),
        data: ch,
        children: get_children(ch, items)
      }
      |> add_min_datetime()
    end)
    |> Enum.sort_by(fn node -> node.min_datetime end, &<=/2)
  end

  defp add_min_datetime(%Node{} = node), do: %Node{node | min_datetime: min_children_time(node)}

  defp get_roots(items) do
    uuids =
      Enum.map(items, fn i -> i.uuid end)
      |> Enum.filter(fn i -> i != nil end)

    Enum.filter(items, fn i -> not Enum.member?(uuids, i.causation_id) end)
  end

  defp content(%CommandAudit{type: type}), do: type |> String.replace("Elixir.", "[Com] ")
  defp content(%EventAudit{type: type}), do: type |> String.replace("Elixir.", "[Evt] ")
end
