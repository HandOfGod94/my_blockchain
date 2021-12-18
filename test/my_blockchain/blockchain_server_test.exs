defmodule MyBlockchain.BlockChainServerTest do
  use ExUnit.Case
  doctest MyBlockchain.BlockChainServer
  alias MyBlockchain.BlockChainServer
  alias MyBlockchain.Block
  alias MyBlockchain.Transaction

  describe "BlockChainServer api" do
    setup do
      genesis = %Block{id: Nanoid.generate(), previous_hash: 1, proof: 100}
      BlockChainServer.start_link(genesis)

      :ok
    end

    test "latest_block returns last block added in the chain" do
      txn = %Transaction{sender: "gahan", recipient: "foobar", amount: 10}
      [prev_block | _] = BlockChainServer.chain()

      BlockChainServer.mine(txn, 34000, "gahan")
      block = BlockChainServer.latest_block()

      assert block.previous_hash == Block.hash!(prev_block)
      assert block.transcation == txn
    end
  end
end
