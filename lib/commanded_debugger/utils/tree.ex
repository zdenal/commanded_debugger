defmodule CommandedDebugger.Utils.Tree do
  import Ratatouille.View
  import Ratatouille.Constants, only: [color: 1]

  alias CommandedDebugger.{EventAudit, CommandAudit}

  @style_selected [
    color: color(:black),
    background: color(:white)
  ]

  def group_by(items, key) do
    items |> Enum.group_by(fn i -> Map.get(i, key) end)
  end

  def item_to_tree_node({item, idx}, offset, cursor) do
    attrs =
      if not is_nil(cursor) and offset + idx == cursor do
        [content: content(item)] ++ @style_selected
      else
        [content: content(item)]
      end

    tree_node(attrs)
  end

  def correlation_tree(items) do
    roots = get_roots(items)

    Enum.map(roots, fn root ->
      tree_node([content: content(root)], get_children(root, items))
    end)
  end

  defp get_children(root, items) do
    children = Enum.filter(items, fn i -> i.causation_id == root.uuid end)

    Enum.map(children, fn ch -> tree_node([content: content(ch)], get_children(ch, items)) end)
  end

  defp get_roots(items) do
    causation_ids =
      Enum.map(items, fn i -> i.causation_id end)
      |> Enum.filter(fn i -> i != nil end)

    Enum.filter(items, fn i -> not Enum.member?(causation_ids, i.causation_id) end)
  end

  defp content(%CommandAudit{type: type}), do: type |> String.replace("Elixir.", "[Com] ")
  defp content(%EventAudit{type: type}), do: type |> String.replace("Elixir.", "[Evt] ")
end
