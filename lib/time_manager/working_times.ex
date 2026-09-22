defmodule TimeManager.WorkingTimes do
  import Ecto.Query, warn: false

  alias TimeManager.Repo
  alias TimeManager.WorkingTime

  def list_working_times(user_id) do
    Repo.all(
      from wt in WorkingTime,
        where: wt.user_id == ^user_id,
        order_by: [asc: wt.start]
    )
  end

  def get_working_time!(id) do
    Repo.get!(WorkingTime, id)
  end

  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end
end
