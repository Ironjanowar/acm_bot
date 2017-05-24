defmodule Step do
  use GenServer

  require Logger

  def start_link do
    GenServer.start_link __MODULE__, :ok, [name: :step]
  end

  def init(:ok) do
    {:ok, %{}}
  end

  # step can be -> :link, :description
  def add_user(uid) do
    GenServer.cast(:step, {:add, uid})
  end

  def del_user(uid) do
    GenServer.cast(:step, {:del, uid})
  end

  def next(uid) do
    GenServer.cast(:step, {:next, uid})
  end

  def get_step(uid) do
    GenServer.call(:step, {:getstep, uid})
  end


  ### Handlers
  # Casts
  def handle_cast({:add, uid}, state) do
    {:noreply, Map.put(state, uid, :description)}
  end

  def handle_cast({:next, uid}, state) do
    case Map.get state, uid do
      :description -> {:noreply, Map.put(state, uid, :link)}
      _ -> Logger.warn "Step.next/1 called in the wrong place"
    end
  end

  def handle_cast({:del, uid}, state) do
    {:noreply, Map.delete(state, uid)}
  end

  # Calls
  def handle_call({:getstep, uid}, _from, state) do
    {:reply, {:ok, Map.get(state, uid)}, state}
  end
end
