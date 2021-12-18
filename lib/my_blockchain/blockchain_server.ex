defmodule MyBlockchain.BlockChainServer do
  use GenServer
  require Logger
  alias MyBlockchain.{Block, Transaction}
  alias MyBlockchain.Transaction.Publisher

  ## client apis

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def mine(transaction, proof, miner) do
    GenServer.call(__MODULE__, {:mine, transaction, proof, miner})
  end

  def chain do
    GenServer.call(__MODULE__, {:chain})
  end

  def latest_block do
    GenServer.call(__MODULE__, {:latest_block})
  end

  ## server handlers

  def init(%Block{} = genesis_block) do
    Logger.info("starting blockchain server")
    {:ok, [genesis_block]}
  end

  def handle_call({:chain}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:latest_block}, _from, ledger) do
    [head | _] = ledger
    {:reply, head, ledger}
  end

  def handle_call({:mine, transaction, proof, miner}, _from, ledger) do
    Logger.info("creating new block")
    head_block = Enum.at(ledger, 0)

    valid_proof? =
      head_block
      |> Map.get(:proof)
      |> MyBlockchain.valid_proof?(proof)

    if valid_proof? do
      new_block = Block.new(transaction, proof, Block.hash!(head_block))
      reward_miner(miner)
      {:reply, {:ok, {:new_block_forged, new_block.id}}, [new_block | ledger]}
    else
      {:reply, {:error, :invalid_proof}, ledger}
    end
  end

  defp reward_miner(miner) do
    Publisher.publish_transaction(%Transaction{sender: "0", recipient: miner, amount: 1})
  end
end
