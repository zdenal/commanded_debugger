defmodule CommandedDebugger.Buffer do
  use GenServer

  @process_name Application.get_env(:commanded_debugger, :buffer)

  alias CommandedDebugger.CommandAudit

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: @process_name)
  end

  def push(item) do
    GenServer.cast({@process_name, node_address}, {:push, item})
  end

  def get_state() do
    GenServer.call({@process_name, node_address}, :get_state)
  end

  def update(uuid, data) do
    GenServer.cast({@process_name, node_address}, {:update, {uuid, data}})
  end

  def node_address do
    [_ | host] = Node.self() |> Atom.to_string() |> String.split("@")

    ["CommandedDebugger" | host] |> Enum.join("@") |> String.to_atom()
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end

  @impl true
  def handle_cast({:update, {uuid, data}}, state) do
    {:noreply, state |> Enum.map(&update_data(&1, {uuid, data}))}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  defp update_data(%CommandAudit{uuid: command_uuid} = command, {uuid, data})
       when command_uuid == uuid,
       do: %CommandAudit{command | callback_data: data}

  defp update_data(item, _), do: item
end
