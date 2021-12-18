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

  def init(transaction_ledger) do
    Logger.info("starting transaction subscriber")

    {:consumer, transaction_ledger, subscribe_to: [Publisher]}
  end

  def handle_call({:transactions}, _from, transaction_ledger) do
    {:reply, transaction_ledger, [], transaction_ledger}
  end

  def handle_events(transactions, _from, transaction_ledger) do
    {:noreply, [], transactions ++ transaction_ledger}
  end
end
