defmodule MyBlockchain.Transaction.Subscriber do
  use GenStage
  require Logger
  alias MyBlockchain.Transaction.Publisher

  ## client apis

  def start_link(init_args) do
    GenStage.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def transactions(timeout \\ 5000) do
    GenStage.call(__MODULE__, {:transactions}, timeout)
  end

  ## server apis

  def init(state) do
    Logger.info("starting transaction subscriber")

    {:consumer, state, subscribe_to: [Publisher]}
  end

  def handle_call({:transactions}, _from, state) do
    {:reply, state, [], state}
  end

  def handle_events(events, _from, state) do
    {:noreply, [], events ++ state}
  end
end
