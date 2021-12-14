defmodule MyBlockchain.TransactionServerTest do
  use ExUnit.Case, async: true
  doctest MyBlockchain.TransactionServer
  alias MyBlockchain.TransactionServer
  alias MyBlockchain.Block.Transaction

  setup do
    TransactionServer.start_link([])

    :ok
  end

  test "new_transaction appends new transaction entry" do
    txn = %Transaction{sender: "gahan", recipient: "foobar", amount: 10}
    TransactionServer.new_transaction(txn)
    [head | _] = TransactionServer.transactions()
    assert head == txn
  end
end
