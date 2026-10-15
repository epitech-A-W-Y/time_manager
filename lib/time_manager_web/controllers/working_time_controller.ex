defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTime
  alias TimeManager.Users

  def index(conn, %{"user_id" => user_id} = params) do
    user = conn.assigns.current_user

    cond do
      not can_view_user?(user, user_id) ->
        forbidden(conn)

      is_nil(Users.get_user(user_id)) ->
        send_resp(conn, :not_found, "")

      true ->
        working_times =
          WorkingTimes.list_working_times(user_id)
          |> filter_by_date(params)

        render(conn, :index, working_times: working_times)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    if to_string(working_time.user_id) == to_string(user_id) and
         can_view_user?(conn.assigns.current_user, user_id) do
      render(conn, :show, working_time: working_time)
    else
      forbidden(conn)
    end
  end

  def create(conn, %{"user_id" => user_id, "workingtime" => params}) do
    user = conn.assigns.current_user

    cond do
      not can_modify_user?(user, user_id) ->
        forbidden(conn)

      is_nil(Users.get_user(user_id)) ->
        send_resp(conn, :not_found, "")

      true ->
        attrs = Map.put(params, "user_id", user_id)

        case WorkingTimes.create_working_time(attrs) do
          {:ok, %WorkingTime{} = working_time} ->
            conn
            |> put_status(:created)
            |> render(:show, working_time: working_time)

          {:error, %Ecto.Changeset{} = changeset} ->
            validation_error(conn, changeset)
        end
    end
  end

  def update(conn, %{"id" => id, "workingtime" => params}) do
    working_time = WorkingTimes.get_working_time!(id)
    owner_id = to_string(working_time.user_id)

    if can_modify_user?(conn.assigns.current_user, owner_id) do
      attrs = Map.delete(params, "user_id")

      case WorkingTimes.update_working_time(working_time, attrs) do
        {:ok, %WorkingTime{} = updated} ->
          render(conn, :show, working_time: updated)

        {:error, %Ecto.Changeset{} = changeset} ->
          validation_error(conn, changeset)
      end
    else
      forbidden(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)
    owner_id = to_string(working_time.user_id)

    if can_modify_user?(conn.assigns.current_user, owner_id) do
      case WorkingTimes.delete_working_time(working_time) do
        {:ok, %WorkingTime{}} ->
          send_resp(conn, :no_content, "")

        {:error, %Ecto.Changeset{} = changeset} ->
          validation_error(conn, changeset)
      end
    else
      forbidden(conn)
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
    role = Map.get(user, :role)
    legacy_role = Map.get(user, :legacy_role)

    case role do
      %{label: label} ->
        String.downcase(label || "")

      label when is_binary(label) ->
        String.downcase(label)

      _ ->
        String.downcase(legacy_role || "")
    end
  end

  defp forbidden(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "You do not have permission to access this working time"})
  end

  defp validation_error(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(TimeManagerWeb.ChangesetJSON, :error, changeset: changeset)
  end

  defp filter_by_date(working_times, %{"start" => start, "end" => ending}) do
    case {DateTime.from_iso8601(start), DateTime.from_iso8601(ending)} do
      {{:ok, start_datetime, _}, {:ok, end_datetime, _}} ->
        Enum.filter(working_times, fn working_time ->
          DateTime.compare(working_time.start, start_datetime) != :lt and
            DateTime.compare(working_time.end, end_datetime) != :gt
        end)

      _ ->
        working_times
    end
  end

  defp filter_by_date(working_times, _params), do: working_times
end
