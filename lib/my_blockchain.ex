defmodule MyBlockchain do
  alias :crypto, as: Crypto

  @doc """
  we will be using a sample proof of work algo.

  Goal to determine poof for work will be:
  * find a number `p` such that `hash(pp')` contains 2 leading zeroes
  p = previous proof
  p' = new proof
  """
  def proof_of_work(last_proof) do
    intial_proof = 0

    intial_proof
    |> Stream.iterate(&(&1 + 1))
    |> Enum.find(&valid_proof(last_proof, &1))
  end

  defp valid_proof(last_proof, new_proof) do
    "#{last_proof}#{new_proof}"
    |> then(&Crypto.hash(:sha256, &1))
    |> Base.encode16()
    |> Integer.parse(16)
    |> elem(0)
    |> Integer.to_string()
    |> String.slice(-4..-1)
    |> Kernel.==("0000")
  end
end
