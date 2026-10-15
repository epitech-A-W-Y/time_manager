defmodule TimeManager.Auth.Token do
  use Joken.Config, default_signer: :default_signer

  @thirty_days 30 * 24 * 60 * 60

  @impl true
  def token_config do
    default_claims(default_exp: @thirty_days)
  end
end
