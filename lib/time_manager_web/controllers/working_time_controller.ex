defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTime

  def index(conn, %{"user_id" => user_id} = params) do
    working_times = WorkingTimes.list_working_times(user_id)

    working_times =
      working_times
      |> filter_by_date(params)

    render(conn, :index, working_times: working_times)
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    if to_string(working_time.user_id) == user_id do
      render(conn, :show, working_time: working_time)
    else
      send_resp(conn, :not_found, "")
    end
  end

  def create(conn, %{"user_id" => user_id, "workingtime" => working_time_params}) do
    working_time_params = Map.put(working_time_params, "user_id", user_id)

    with {:ok, %WorkingTime{} = working_time} <-
           WorkingTimes.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> render(:show, working_time: working_time)
    end
  end

  def update(conn, %{"id" => id, "workingtime" => working_time_params}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <-
           WorkingTimes.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkingTimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end

  defp filter_by_date(working_times, %{"start" => start, "end" => ending}) do
    Enum.filter(working_times, fn working_time ->
      DateTime.compare(working_time.start, parse_datetime(start)) != :lt and
        DateTime.compare(working_time.end, parse_datetime(ending)) != :gt
    end)
  end

  defp filter_by_date(working_times, _params), do: working_times

  defp parse_datetime(value) do
    {:ok, datetime, _offset} = DateTime.from_iso8601(value)
    datetime
  end
end
