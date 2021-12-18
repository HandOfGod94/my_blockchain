defmodule MyBlockchain.Transaction do
  @derive Jason.Encoder
  defstruct [:sender, :recipient, :amount]
end
