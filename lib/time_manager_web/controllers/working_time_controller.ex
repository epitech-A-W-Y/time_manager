defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTime
  alias TimeManager.Users

  def index(conn, %{"user_id" => user_id} = params) do
    case Users.get_user(user_id) do
      nil ->
        send_resp(conn, :not_found, "")

      _user ->
        working_times =
          user_id
          |> WorkingTimes.list_working_times()
          |> filter_by_date(params)

        render(conn, :index, working_times: working_times)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    if to_string(working_time.user_id) == user_id do
      render(conn, :show, working_time: working_time)
    else
      send_resp(conn, :not_found, "")
    end
  end

  def create(conn, %{"user_id" => user_id} = params) do
    case Users.get_user(user_id) do
      nil ->
        send_resp(conn, :not_found, "")

      _user ->
        working_time_params =
          params
          |> Map.delete("user_id")
          |> Map.put("user_id", user_id)

        case WorkingTimes.create_working_time(working_time_params) do
          {:ok, %WorkingTime{} = working_time} ->
            conn
            |> put_status(:created)
            |> render(:show, working_time: working_time)

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

  def update(conn, %{"id" => id} = params) do
    working_time = WorkingTimes.get_working_time!(id)

    working_time_params =
      Map.drop(params, ["id"])

    case WorkingTimes.update_working_time(
           working_time,
           working_time_params
         ) do
      {:ok, %WorkingTime{} = working_time} ->
        render(conn, :show, working_time: working_time)

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

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    case WorkingTimes.delete_working_time(working_time) do
      {:ok, %WorkingTime{}} ->
        send_resp(conn, :no_content, "")

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

  defp filter_by_date(working_times, %{
         "start" => start,
         "end" => ending
       }) do
    start_datetime = parse_datetime(start)
    end_datetime = parse_datetime(ending)

    Enum.filter(working_times, fn working_time ->
      DateTime.compare(working_time.start, start_datetime) != :lt and
        DateTime.compare(working_time.end, end_datetime) != :gt
    end)
  end

  defp filter_by_date(working_times, _params) do
    working_times
  end

  defp parse_datetime(value) do
    {:ok, datetime, _offset} = DateTime.from_iso8601(value)
    datetime
  end
end
