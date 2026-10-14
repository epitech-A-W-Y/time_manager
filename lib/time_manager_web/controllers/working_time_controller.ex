
defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTime

  def index(conn, %{"user_id" => user_id} = params) do
    if authorized_user?(conn, user_id) do
      case filter_by_date(WorkingTimes.list_working_times(user_id), params) do
        {:ok, working_times} ->
          render(conn, :index, working_times: working_times)

        {:error, message} ->
          conn
          |> put_status(:bad_request)
          |> json(%{error: message})
      end
    else
      forbidden(conn)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    if authorized_user?(conn, user_id) do
      working_time = WorkingTimes.get_working_time!(id)

      if to_string(working_time.user_id) ==
           to_string(conn.assigns.current_user_id) do
        render(conn, :show, working_time: working_time)
      else
        forbidden(conn)
      end
    else
      forbidden(conn)
    end
  end

  def create(conn, %{"user_id" => user_id, "workingtime" => params}) do
    if authorized_user?(conn, user_id) do
      params =
        Map.put(params, "user_id", conn.assigns.current_user_id)

      with {:ok, %WorkingTime{} = working_time} <-
             WorkingTimes.create_working_time(params) do
        conn
        |> put_status(:created)
        |> render(:show, working_time: working_time)
      end
    else
      forbidden(conn)
    end
  end

  def update(conn, %{"id" => id, "workingtime" => params}) do
    working_time = WorkingTimes.get_working_time!(id)

    if to_string(working_time.user_id) ==
         to_string(conn.assigns.current_user_id) do
      params = Map.delete(params, "user_id")

      with {:ok, %WorkingTime{} = updated} <-
             WorkingTimes.update_working_time(working_time, params) do
        render(conn, :show, working_time: updated)
      end
    else
      forbidden(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    if to_string(working_time.user_id) ==
         to_string(conn.assigns.current_user_id) do
      with {:ok, %WorkingTime{}} <-
             WorkingTimes.delete_working_time(working_time) do
        send_resp(conn, :no_content, "")
      end
    else
      forbidden(conn)
    end
  end

  defp authorized_user?(conn, user_id) do
    to_string(conn.assigns.current_user_id) == to_string(user_id)
  end

  defp forbidden(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "Forbidden"})
  end

  defp filter_by_date(working_times, %{"start" => start, "end" => ending}) do
    with {:ok, start_datetime, _offset} <- DateTime.from_iso8601(start),
         {:ok, end_datetime, _offset} <- DateTime.from_iso8601(ending),
         true <- DateTime.compare(start_datetime, end_datetime) != :gt do
      filtered =
        Enum.filter(working_times, fn working_time ->
          DateTime.compare(working_time.start, start_datetime) != :lt and
            DateTime.compare(working_time.end, end_datetime) != :gt
        end)

      {:ok, filtered}
    else
      _ ->
        {:error, "Invalid date range. Use ISO-8601 dates with a timezone."}
    end
  end

  defp filter_by_date(working_times, _params), do: {:ok, working_times}
end
