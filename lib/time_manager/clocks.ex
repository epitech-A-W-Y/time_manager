defmodule TimeManager.Clocks do
  import Ecto.Query, warn: false

  alias TimeManager.Repo
  alias TimeManager.Clock

  def list_clocks(user_id) do
    Repo.all(
      from clock in Clock,
        where: clock.user_id == ^user_id,
        order_by: [asc: clock.time]
    )
  end

  def get_clock!(id) do
    Repo.get!(Clock, id)
  end

  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end
end
