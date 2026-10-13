defmodule TimeManagerWeb.Plugs.AuthPlug do
  import Plug.Conn

  alias TimeManager.Auth.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    with cookie_header when is_binary(cookie_header) <-
           get_req_header(conn, "cookie") |> List.first(),
         jwt when is_binary(jwt) <- extract_jwt(cookie_header),
         {:ok, claims} <- Token.verify_and_validate(jwt),
         xsrf_token when is_binary(xsrf_token) <- claims["xsrf_token"],
         [request_xsrf] <- get_req_header(conn, "x-xsrf-token"),
         true <- request_xsrf == xsrf_token do
      conn
      |> assign(:current_user_id, claims["user_id"])
      |> assign(:current_role, claims["role"])
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "Unauthorized"})
        |> halt()
    end
  end

  defp extract_jwt(cookie_header) do
    cookie_header
    |> String.split(";")
    |> Enum.map(&String.trim/1)
    |> Enum.find_value(fn cookie ->
      case String.split(cookie, "=", parts: 2) do
        ["jwt", value] -> value
        _ -> nil
      end
    end)
  end
end
