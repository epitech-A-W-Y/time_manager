defmodule TimeManagerWeb.SessionController do
  use TimeManagerWeb, :controller

  alias TimeManager.Users

  def create(conn, %{"email" => email, "password" => password})
      when is_binary(email) and is_binary(password) do
    user =
      Users.list_users(%{"email" => email})
      |> List.first()

    valid_password? =
      if user && is_binary(user.hashed_password) do
        Argon2.verify_pass(password, user.hashed_password)
      else
        Argon2.no_user_verify()
        false
      end

    if valid_password? do
      conn
      |> configure_session(renew: true)
      |> clear_session()
      |> put_session(:user_id, user.id)
      |> json(%{
        message: "Login successful",
        user: %{
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role
        }
      })
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Invalid email or password"})
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Email and password are required"})
  end
end
