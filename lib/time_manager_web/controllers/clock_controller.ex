
defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Clocks
  alias TimeManager.Clock

  def index(conn, %{"user_id" => user_id}) do
    current_user = conn.assigns.current_user

    if can_view_user?(current_user, user_id) do
      clocks = Clocks.list_clocks(user_id)
      render(conn, :index, clocks: clocks)
    else
      forbidden(conn)
    end
  end

  def create(conn, %{"user_id" => user_id, "clock" => clock_params}) do
    current_user = conn.assigns.current_user

    # Only admins can create clock records for other users.
    if can_modify_user?(current_user, user_id) do
      clock_params = Map.put(clock_params, "user_id", user_id)

      with {:ok, %Clock{} = clock} <-
             Clocks.create_clock(clock_params) do
        conn
        |> put_status(:created)
        |> render(:show, clock: clock)
      end
    else
      forbidden(conn)
    end
  end

  defp can_view_user?(user, user_id) do
    role = role_label(user)

    role in ["admin", "manager"] or
      to_string(user.id) == user_id
  end

  defp can_modify_user?(user, user_id) do
    role_label(user) == "admin" or
      to_string(user.id) == user_id
  end

  defp role_label(user) do
    case user.role do
      %TimeManager.Accounts.Role{label: label} ->
        String.downcase(label || "")

      _ ->
        String.downcase(user.legacy_role || "")
    end
  end

  defp forbidden(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "You do not have permission to access this user's clocks"})
  end
end

