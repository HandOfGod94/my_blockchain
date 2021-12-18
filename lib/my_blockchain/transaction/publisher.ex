defmodule MyBlockchain.Transaction.Publisher do
  use GenStage
  alias MyBlockchain.Transaction

  ## client apis

  def start_link(_init_args) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def publish_transaction_created(%Transaction{} = txn, timeout \\ 5000) do
    GenStage.call(__MODULE__, {:transaction_created, txn}, timeout)
  end

  ## server apis

  def init(:ok) do
    {:producer, :ok, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_call({:transaction_created, event}, _from, state) do
    {:reply, :ok, [event], state}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
