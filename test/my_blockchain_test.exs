defmodule MyBlockchainTest do
  use ExUnit.Case
  doctest MyBlockchain

  test "greets the world" do
    assert MyBlockchain.hello() == :world
  end
end
