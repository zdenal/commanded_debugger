defmodule CommandedDebugger.Debugger do
  @behaviour Ratatouille.App

  import Ratatouille.Constants, only: [key: 1]
  import Ratatouille.View

  alias CommandedDebugger.Buffer
  alias Ratatouille.Runtime.{Subscription, Command}
  alias CommandedDebugger.{EventAudit, CommandAudit}
  alias CommandedDebugger.Utils.Tree

  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)

  def init(_context) do
    buffer = Buffer.get_state()

    model = %{
      content: %{},
      content_cursor: 0,
      module_cursor: 0,
      buffer: buffer
    }

    {model, update_cmd(model)}
  end

  def update(
        %{
          content_cursor: content_cursor,
          module_cursor: module_cursor,
          buffer: buffer
        } = model,
        msg
      ) do
    case msg do
      {:event, %{ch: ?k}} ->
        %{model | content_cursor: max(content_cursor - 1, 0)}

      {:event, %{ch: ?j}} ->
        %{model | content_cursor: content_cursor + 1}

      {:event, %{key: key}} when key in [@arrow_up, @arrow_down] ->
        new_cursor =
          case key do
            @arrow_up -> max(module_cursor - 1, 0)
            @arrow_down -> min(module_cursor + 1, length(buffer) - 1)
          end

        new_model = %{model | module_cursor: new_cursor}
        {new_model, update_cmd(new_model)}

      :refresh ->
        %{model | buffer: Buffer.get_state()}

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
    selected = Enum.at(model.buffer, model.module_cursor)

    menu_bar =
      bar do
        label(content: header(), color: :white)
      end

    view(top_bar: menu_bar) do
      row do
        column(size: 7) do
          panel(title: "Commands / Events", height: :fill) do
            # viewport(offset_y: model.module_cursor) do
            viewport do
              # for {item, idx} <- Enum.with_index(model.buffer) do
              # if idx == model.module_cursor do
              # label(content: "> " <> title(item), attributes: [:bold])
              # else
              # label(content: title(item))
              # end
              # end
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

  defp tree_view(%{buffer: buffer, module_cursor: cursor}) do
    tree do
      for {correlation_id, items} <- Tree.group_by(buffer, :correlation_id) do
        tree_node(
          [content: correlation_id],
          Tree.correlation_tree(items)
        )
      end
    end
  end

  defp update_cmd(model) do
    Command.new(fn -> fetch_content(model) end, :content_updated)
  end

  defp fetch_content(%{module_cursor: cursor, buffer: buffer}) do
    Enum.at(buffer, cursor)
  end

  defp display_content(%_{data: data} = item) do
    Map.from_struct(item) |> Map.put(:data, Jason.decode!(data)) |> Jason.encode!(pretty: true)
  end

  defp display_content(_), do: ""

  defp title(%CommandAudit{type: type}), do: type |> String.replace("Elixir.", "[C] ")
  defp title(%EventAudit{type: type}), do: type |> String.replace("Elixir.", "[E] ")
  defp title(nil), do: "Nothing selected"

  defp header do
    "Commanded Debugger (UP/DOWN to select command/event, j/k to scroll content). Node: #{
      Node.self()
    }"
  end
end
