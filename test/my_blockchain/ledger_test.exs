defmodule MyBlockchain.LedgerTest do
  use ExUnit.Case
  doctest MyBlockchain.Ledger
  alias MyBlockchain.Ledger
  alias MyBlockchain.Block
  alias MyBlockchain.Block.Transaction

  describe "ledger api" do
    setup do
      genesis = %Block{id: Nanoid.generate(), previous_hash: 1, proof: 100}
      Ledger.start_link(genesis)

      :ok
    end

    test "new_transaction appends new block to exisiting ledger" do
      txn = %Transaction{sender: "gahan", recipient: "foobar", amount: 10}
      [prev_block | _] = Ledger.chain()

      Ledger.new_transaction(txn)
      [head | _] = Ledger.chain()

      assert head.previous_hash == Block.hash!(prev_block)
      assert head.transcation == txn
    end

    test "latest_block returns last block added in the chain" do
      txn = %Transaction{sender: "gahan", recipient: "foobar", amount: 10}
      [prev_block | _] = Ledger.chain()

      Ledger.new_transaction(txn)
      block = Ledger.latest_block()

      assert block.previous_hash == Block.hash!(prev_block)
      assert block.transcation == txn
    end
  end
end
