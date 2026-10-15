
defmodule TimeManagerWeb.AdminPlug do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = conn.assigns[:current_user]
    role = current_user && current_user.role

    if role && String.downcase(role.label || "") == "admin" do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Admin access required"})
      |> halt()
    end
  end
end
