defmodule MyBlockchain.Transaction.Publisher do
  use GenStage
  require Logger
  alias MyBlockchain.Transaction

  ## client apis

  def start_link(_init_args) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def publish_transaction(%Transaction{} = txn, timeout \\ 5000) do
    GenStage.call(__MODULE__, {:transaction, txn}, timeout)
  end

  ## server apis

  def init(:ok) do
    Logger.info("starting transaction publisher")
    {:producer, :ok, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_call({:transaction, event}, _from, state) do
    Logger.info("publishing transaction")
    {:reply, {:ok, :create_transaction_event}, [event], state}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
