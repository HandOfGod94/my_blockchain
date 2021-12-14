defmodule MyBlockchain.BlockChainServer do
  use GenServer
  require Logger
  alias MyBlockchain.Block
  alias MyBlockchain.TransactionServer
  alias MyBlockchain.Block.Transaction

  def init(%Block{} = genesis_block) do
    Logger.info("starting ledeger server")
    {:ok, [genesis_block]}
  end

  def handle_call({:chain}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:latest_block}, _from, ledger) do
    [head | _] = ledger
    {:reply, head, ledger}
  end

  def handle_call({:mine, transaction, proof}, from, ledger) do
    Logger.info("creating new block")
    [ledger_head_block | _] = ledger

    new_block = %Block{
      id: Nanoid.generate(),
      transcation: transaction,
      proof: proof,
      previous_hash: Block.hash!(ledger_head_block)
    }

    # reward miner
    TransactionServer.new_transaction(%Transaction{
      sender: "0",
      recipient: from,
      amount: 1
    })

    {:reply, {:ok, {:new_block_forged, new_block.id}}, [new_block | ledger]}
  end

  ## Client Apis

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def mine(%Transaction{} = transaction, proof) do
    GenServer.call(__MODULE__, {:mine, transaction, proof})
  end

  def chain do
    GenServer.call(__MODULE__, {:chain})
  end

  def latest_block do
    GenServer.call(__MODULE__, {:latest_block})
  end
end