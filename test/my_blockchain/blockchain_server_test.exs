defmodule MyBlockchain.BlockChainServerTest do
  use ExUnit.Case
  doctest MyBlockchain.BlockChainServer
  alias MyBlockchain.BlockChainServer
  alias MyBlockchain.Block
  alias MyBlockchain.Transaction

  describe "BlockChainServer api" do
    setup do
      genesis = %Block{id: Nanoid.generate(), previous_hash: 1, proof: 100}
      new_proof = MyBlockchain.proof_of_work(genesis.proof)
      BlockChainServer.start_link(genesis)

      %{valid_proof: new_proof}
    end

    test "latest_block returns last block added in the chain", %{valid_proof: valid_proof} do
      txn = %Transaction{sender: "gahan", recipient: "foobar", amount: 10}
      [prev_block | _] = BlockChainServer.chain()

      assert {:ok, {:new_block_forged, _}} = BlockChainServer.mine(txn, valid_proof, "gahan")

      block = BlockChainServer.latest_block()

      assert block.previous_hash == Block.hash!(prev_block)
      assert block.transaction == txn
    end

    test "should not create new block with invalid proof" do
      assert {:error, :invalid_proof} = BlockChainServer.mine(nil, 100, "gahan")
    end
  end
end
