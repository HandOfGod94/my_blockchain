defmodule MyBlockchain.Transaction.PublisherTest do
  use ExUnit.Case, async: false
  doctest MyBlockchain.Transaction.Publisher
  alias MyBlockchain.Transaction.Publisher
  alias MyBlockchain.Transaction

  setup do
    {:ok, publisher} = Publisher.start_link(:ok)

    on_exit(fn -> Process.exit(publisher, :normal) end)
    %{publisher: publisher}
  end

  test "publishing transaction created event", %{publisher: publisher} do
    txn = %Transaction{sender: "bob", recipient: "alice", amount: 3000}
    Publisher.publish_transaction(txn)
    [result | _] = GenStage.stream([publisher]) |> Enum.take(1)

    assert result == txn
  end
end
