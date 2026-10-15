defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Clocks
  alias TimeManager.Users
  alias TimeManager.Accounts.Role

  def index(conn, %{"user_id" => user_id}) do
    current_user = conn.assigns.current_user

    cond do
      not can_view_user?(current_user, user_id) ->
        forbidden(conn)

      is_nil(Users.get_user(user_id)) ->
        send_resp(conn, :not_found, "")

      true ->
        clocks = Clocks.list_clocks(user_id)
        render(conn, :index, clocks: clocks)
    end
  end

  def create(conn, %{"user_id" => user_id}) do
    current_user = conn.assigns.current_user

    cond do
      not can_modify_user?(current_user, user_id) ->
        forbidden(conn)

      is_nil(Users.get_user(user_id)) ->
        send_resp(conn, :not_found, "")

      true ->
        clocks = Clocks.list_clocks(user_id)

        status =
          case List.last(clocks) do
            nil -> true
            last_clock -> !last_clock.status
          end

        attrs = %{
          "time" => DateTime.utc_now(),
          "status" => status,
          "user_id" => user_id
        }

        case Clocks.create_clock(attrs) do
          {:ok, clock} ->
            conn
            |> put_status(:created)
            |> render(:show, clock: clock)

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(TimeManagerWeb.ChangesetJSON, :error,
              changeset: changeset
            )
        end
    end
  end

  defp can_view_user?(user, user_id) do
    role_label(user) in ["admin", "manager"] or
      to_string(user.id) == to_string(user_id)
  end

  defp can_modify_user?(user, user_id) do
    role_label(user) == "admin" or
      to_string(user.id) == to_string(user_id)
  end

  defp role_label(user) do
    case user.role do
      %Role{label: label} ->
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
