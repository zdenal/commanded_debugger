defmodule CommandedDebugger.Debugger do
  @behaviour Ratatouille.App

  import Ratatouille.Constants, only: [key: 1, color: 1]
  import Ratatouille.View

  alias CommandedDebugger.Buffer
  alias Ratatouille.Runtime.{Subscription, Command}
  alias CommandedDebugger.{EventAudit, CommandAudit}
  alias CommandedDebugger.Utils.Tree

  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)

  @style_selected [
    color: color(:black),
    background: color(:white)
  ]

  def init(_context) do
    buffer = Buffer.get_state()

    model = %{
      content: %{},
      content_cursor: 0,
      tree_cursor: [],
      buffer: buffer,
      trees: Tree.correlation_trees(buffer)
    }

    {model, update_cmd(model)}
  end

  def update(
        %{
          content_cursor: content_cursor,
          tree_cursor: tree_cursor,
          trees: trees,
          buffer: buffer
        } = model,
        msg
      ) do
    case msg do
      {:event, %{ch: ?r}} ->
        Buffer.reset()
        %{model | buffer: [], trees: [], content: %{}}

      {:event, %{ch: ?k}} ->
        %{model | content_cursor: max(content_cursor - 1, 0)}

      {:event, %{ch: ?k}} ->
        %{model | content_cursor: max(content_cursor - 1, 0)}

      {:event, %{ch: ?j}} ->
        %{model | content_cursor: content_cursor + 1}

      {:event, %{key: key}} when key in [@arrow_up, @arrow_down] ->
        new_cursor =
          case key do
            @arrow_up -> Tree.move_cursor(trees, tree_cursor, :up)
            @arrow_down -> Tree.move_cursor(trees, tree_cursor, :down)
          end

        new_model = %{model | tree_cursor: new_cursor}
        {new_model, update_cmd(new_model)}

      :refresh ->
        new_buffer = Buffer.get_state()
        %{model | buffer: new_buffer, trees: Tree.correlation_trees(new_buffer)}

      {:content_updated, content} ->
        %{model | content: content}

      _ ->
        model
    end
  end

  def subscribe(_model) do
    Subscription.batch([
      Subscription.interval(1000, :refresh)
    ])
  end

  def render(model) do
    selected = get_selected(model)

    menu_bar =
      bar do
        label(content: header(), color: :white)
      end

    view(top_bar: menu_bar) do
      row do
        column(size: 7) do
          panel(title: "Commands / Events", height: :fill) do
            # viewport(offset_y: model.tree_cursor) do
            viewport do
              tree_view(model)
            end
          end
        end

        column(size: 5) do
          panel(title: title(selected), height: :fill) do
            viewport(offset_y: model.content_cursor) do
              label(content: display_content(model.content))
            end
          end
        end
      end
    end
  end

  defp tree_view(%{trees: trees, tree_cursor: cursor}) do
    tree do
      Enum.map(trees, &node_to_tree(&1, cursor))
    end
  end

  defp node_to_tree(node, cursor) do
    current_cursor = List.first(cursor)

    attrs =
      if current_cursor && current_cursor.uuid == node.uuid do
        [content: node.content] ++ @style_selected
      else
        [content: node.content]
      end

    tree_node(
      attrs,
      Enum.map(node.children, &node_to_tree(&1, cursor))
    )
  end

  defp update_cmd(model) do
    Command.new(fn -> get_selected(model) end, :content_updated)
  end

  defp get_selected(%{tree_cursor: []}), do: nil

  defp get_selected(%{tree_cursor: [current_node | _], buffer: buffer}),
    do: Enum.find(buffer, fn b -> b.uuid == current_node.uuid end)

  defp display_content(%_{data: data} = item) do
    Map.from_struct(item) |> Map.put(:data, Jason.decode!(data)) |> Jason.encode!(pretty: true)
  end

  defp display_content(_), do: ""

  defp title(%CommandAudit{type: type}), do: type |> String.replace("Elixir.", "[Com] ")
  defp title(%EventAudit{type: type}), do: type |> String.replace("Elixir.", "[Evt] ")
  defp title(nil), do: "Nothing selected"

  defp header do
    "Commanded Debugger (UP/DOWN to select command/event, j/k to scroll content, r to reset buffer). Node: #{
      Node.self()
    }"
  end
end
