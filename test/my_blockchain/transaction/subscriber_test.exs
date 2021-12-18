defmodule MyBlockchain.Transaction.SubscriberTest do
  use ExUnit.Case, async: true
  doctest MyBlockchain.Transaction.Subscriber
  alias MyBlockchain.Transaction.Subscriber
  alias MyBlockchain.Transaction
  alias MyBlockchain.Transaction.Publisher

  setup do
    {:ok, publisher} = Publisher.start_link([])
    {:ok, subscriber} = Subscriber.start_link([])

    on_exit(fn ->
      Process.exit(subscriber, :normal)
      Process.exit(publisher, :normal)
    end)

    :ok
  end

  test "consumes transaction created event" do
    txn = %Transaction{sender: "bob", recipient: "alice", amount: 3000}

    Publisher.publish_transaction(txn)
    Publisher.publish_transaction(txn)

    assert Subscriber.transactions() == [txn, txn]
  end
end
