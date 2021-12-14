defmodule MyBlockchain.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  alias MyBlockchain.Block

  use Application

  @genesis_block %Block{id: "1", previous_hash: 1, proof: 100}

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: MyBlockchain.Worker.start_link(arg)
      # {MyBlockchain.Worker, arg}
      MyBlockchain.TransactionServer,
      {MyBlockchain.BlockChainServer, @genesis_block}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyBlockchain.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
