defmodule MyBlockchain.Transaction.PublisherTest do
  use ExUnit.Case, async: true
  doctest MyBlockchain.Transaction.Publisher
  alias MyBlockchain.Transaction.Publisher
  alias MyBlockchain.Transaction

  setup do
    {:ok, publisher} = Publisher.start_link(:ok)
    %{publisher: publisher}
  end

  test "publishing transaction created event", %{publisher: publisher} do
    txn = %Transaction{sender: "bob", recipient: "alice", amount: 3000}
    Publisher.publish_transaction_created(txn)
    [result | _] = GenStage.stream([publisher]) |> Enum.take(1)

    assert result == txn
  end
end