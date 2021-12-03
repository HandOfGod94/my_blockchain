defmodule MyBlockchain.Block do
  alias :crypto, as: Crypto

  @moduledoc """
  Represents a block of the whole blockchain.
  Each block can contain any arbitrary information.
  Such as: `sender`, `recevier`, `transactions`

  However it must contain few required params: `proof` and `previous_hash`
  """

  defmodule Transaction do
    @derive Jason.Encoder
    defstruct [:sender, :recipient, :amount]
  end

  @derive Jason.Encoder
  @enforce_keys [:id, :previous_hash, :proof]
  defstruct [
    :id,
    :transcation,
    :proof,
    :previous_hash,
    timestamp: DateTime.to_unix(DateTime.utc_now())
  ]

  def hash!(%__MODULE__{} = block) do
    Crypto.hash(:md5, Jason.encode!(block))
    |> Base.encode64()
  end
end
