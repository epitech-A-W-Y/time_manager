defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Clocks
  alias TimeManager.Users

  def index(conn, %{"user_id" => user_id}) do
    case Users.get_user(user_id) do
      nil ->
        send_resp(conn, :not_found, "")

      _user ->
        clocks = Clocks.list_clocks(user_id)
        render(conn, :index, clocks: clocks)
    end
  end

  def create(conn, %{"user_id" => user_id}) do
    case Users.get_user(user_id) do
      nil ->
        send_resp(conn, :not_found, "")

      _user ->
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
            |> render(
              TimeManagerWeb.ChangesetJSON,
              :error,
              changeset: changeset
            )
        end
    end
  end
end
