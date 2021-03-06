defmodule CommandedDebugger.Debugger do
  @behaviour Ratatouille.App

  import Ratatouille.Constants, only: [key: 1, color: 1]
  import Ratatouille.View
  import CommandedDebugger.Utils.View

  alias CommandedDebugger.Buffer
  alias Ratatouille.Runtime.{Subscription, Command}
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
      content: nil,
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
          trees: trees
        } = model,
        msg
      ) do
    case msg do
      {:event, %{ch: ?r}} ->
        Buffer.reset()
        %{model | buffer: [], trees: [], content: nil, content_cursor: 0}

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

        new_model = %{model | tree_cursor: new_cursor, content_cursor: 0}
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
            content_view(model)
          end
        end
      end
    end
  end

  defp content_view(%{content: nil}), do: label(content: "")

  defp content_view(%{content_cursor: content_cursor, content: content}) do
    viewport(offset_y: content_cursor) do
      label(content: "Info", attributes: [:bold, :underline])
      label(content: "")

      table do
        table_row do
          table_cell(content: "created_at")
          table_cell(content: display_created_at(content))
        end

        table_row do
          table_cell(content: "correlation_id")
          table_cell(content: content.correlation_id)
        end

        table_row do
          table_cell(content: "causation_id")
          table_cell(content: content.causation_id)
        end

        table_row do
          table_cell(content: "type")
          table_cell(content: content.type)
        end

        table_row do
          table_cell(content: "uuid")
          table_cell(content: content.uuid)
        end
      end

      label(content: "Data", attributes: [:bold, :underline])
      label(content: "")

      label(content: display(content.data))
      label(content: "")

      label(content: "Metadata", attributes: [:bold, :underline])
      label(content: "")
      label(content: content.metadata |> Jason.encode!(pretty: true))
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
end
