defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Auth.Token

  def sign_up(conn, %{
        "username" => username,
        "email" => email,
        "password" => password
      }) do
    attrs = %{
      username: username,
      email: email,
      password: password
    }

    case Accounts.register_user(attrs) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{
          message: "User created successfully",
          id: user.id
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          errors: translate_errors(changeset)
        })
    end
  end

  def sign_up(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{
      error: "username, email and password are required"
    })
  end

  def sign_in(conn, %{
        "email" => email,
        "password" => password
      }) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        xsrf_token = generate_xsrf_token()

        role_label =
          case user.role do
            %TimeManager.Accounts.Role{label: label} -> label
            _ -> "User"
          end

        claims = %{
          "user_id" => user.id,
          "role" => role_label,
          "role_id" => user.role_id,
          "xsrf_token" => xsrf_token
        }

        case Token.generate_and_sign(claims) do
          {:ok, jwt, _claims} ->
            conn
            |> put_resp_cookie(
              "jwt",
              jwt,
              http_only: true,
              max_age: 30 * 24 * 60 * 60,
              same_site: "Lax"
            )
            |> json(%{
              xsrf_token: xsrf_token,
              id: user.id,
              role: role_label,
              role_id: user.role_id
            })

          {:error, reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: inspect(reason)})
        end

      {:error, :invalid_credentials} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{
          error: "Invalid email or password"
        })
    end
  end

  def sign_in(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{
      error: "email and password are required"
    })
  end

  def sign_out(conn, _params) do
    conn
    |> delete_resp_cookie("jwt")
    |> json(%{
      message: "Signed out successfully"
    })
  end

  defp generate_xsrf_token do
    :crypto.strong_rand_bytes(38)
    |> Base.url_encode64(padding: false)
    |> binary_part(0, 50)
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
