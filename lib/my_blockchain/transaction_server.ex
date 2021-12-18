defmodule MyBlockchain.TransactionServer do
  use GenServer
  require Logger
  alias MyBlockchain.Transaction

  @blank_transaction_ledger []

  def init(_opts) do
    Logger.info("starting transaction server")
    {:ok, @blank_transaction_ledger}
  end

  def handle_call({:transactions}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:new_transaction, %Transaction{} = transaction}, transaction_ledger) do
    Logger.info("recording new transaction")
    {:noreply, [transaction | transaction_ledger]}
  end

  ## Client Apis

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def new_transaction(%Transaction{} = transaction) do
    GenServer.cast(__MODULE__, {:new_transaction, transaction})
  end

  def transactions do
    GenServer.call(__MODULE__, {:transactions})
  end
end
