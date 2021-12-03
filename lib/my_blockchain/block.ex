defmodule MyBlockchain.Block do
  @moduledoc """
  Represents a block of the whole blockchain.
  Each block can contain any arbitrary information.
  Such as: `sender`, `recevier`, `transactions`

  However it must contain few required params: `proof` and `previous_hash`
  """

  defmodule Transaction do
    defstruct [:sender, :recipient, :amount]
  end

  defstruct [
    :index,
    :transacitons,
    :proof,
    :previous_hash,
    timestamp: DateTime.to_unix(DateTime.utc_now())
  ]
end
