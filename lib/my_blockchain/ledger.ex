defmodule MyBlockchain.Ledger do
  use GenServer
  alias MyBlockchain.Block
  alias MyBlockchain.Block.Transaction

  def init(%Block{} = genesis_block) do
    {:ok, [genesis_block]}
  end

  def handle_call({:chain}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:new_transaction, transaction}, ledger) do
    [ledger_head_block | _] = ledger

    new_block = %Block{
      id: Nanoid.generate(),
      transcation: transaction,
      proof: rem(Enum.random(1..100), 4),
      previous_hash: Block.hash!(ledger_head_block)
    }

    {:noreply, [new_block | ledger]}
  end

  ## Client Apis

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, init_args, name: LedgerServer)
  end

  def new_transaction(%Transaction{} = transaction) do
    GenServer.cast(LedgerServer, {:new_transaction, transaction})
  end

  def chain do
    GenServer.call(LedgerServer, {:chain})
  end
end