defmodule MyBlockchain.Block do
  alias :crypto, as: Crypto

  @moduledoc """
  Represents a block of the whole blockchain.
  Each block can contain any arbitrary information.
  Such as: `sender`, `recevier`, `transactions`

  However it must contain few required params: `proof` and `previous_hash`
  """

  @derive Jason.Encoder
  @enforce_keys [:id, :previous_hash, :proof]
  defstruct [
    :id,
    :transaction,
    :proof,
    :previous_hash,
    timestamp: DateTime.to_unix(DateTime.utc_now())
  ]

  def new(transaction, proof, previous_hash) do
    %__MODULE__{
      id: Nanoid.generate(),
      transaction: transaction,
      proof: proof,
      previous_hash: previous_hash
    }
  end

  def hash!(%__MODULE__{} = block) do
    block
    |> Jason.encode!()
    |> then(&Crypto.hash(:sha256, &1))
    |> Base.encode64()
  end
end
