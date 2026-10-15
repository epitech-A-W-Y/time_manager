
defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTime

  def index(conn, %{"user_id" => user_id} = params) do
    current_user = conn.assigns.current_user

    if can_view_user?(current_user, user_id) do
      working_times =
        WorkingTimes.list_working_times(user_id)
        |> filter_by_date(params)

      render(conn, :index, working_times: working_times)
    else
      forbidden(conn)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    current_user = conn.assigns.current_user
    working_time = WorkingTimes.get_working_time!(id)

    if to_string(working_time.user_id) == user_id and
         can_view_user?(current_user, user_id) do
      render(conn, :show, working_time: working_time)
    else
      forbidden(conn)
    end
  end

  def create(conn, %{"user_id" => user_id, "workingtime" => params}) do
    current_user = conn.assigns.current_user

    if can_modify_user?(current_user, user_id) do
      params = Map.put(params, "user_id", user_id)

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
    current_user = conn.assigns.current_user
    working_time = WorkingTimes.get_working_time!(id)
    owner_id = to_string(working_time.user_id)

    if can_modify_user?(current_user, owner_id) do
      # Never allow a request to transfer a record to another user.
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
    current_user = conn.assigns.current_user
    working_time = WorkingTimes.get_working_time!(id)
    owner_id = to_string(working_time.user_id)

    if can_modify_user?(current_user, owner_id) do
      with {:ok, %WorkingTime{}} <-
             WorkingTimes.delete_working_time(working_time) do
        send_resp(conn, :no_content, "")
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
    |> json(%{error: "You do not have permission to access this working time"})
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

