defmodule TimeManagerWeb.AuthPlug do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  alias TimeManager.Accounts
  alias TimeManager.Auth.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    conn = fetch_cookies(conn)

    with jwt when is_binary(jwt) <- conn.cookies["jwt"],
         {:ok, claims} <- Token.verify_and_validate(jwt),
         user_id when is_integer(user_id) <- claims["user_id"],
         user when not is_nil(user) <- Accounts.get_user(user_id) do
      assign(conn, :current_user, TimeManager.Repo.preload(user, :role))
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Authentication required"})
        |> halt()
    end
  end
end
