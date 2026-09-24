defmodule TimeManager.Clocks do
  import Ecto.Query, warn: false

  alias TimeManager.Repo
  alias TimeManager.Clock

  def list_clocks(user_id) do
    Repo.all(
      from c in Clock,
        where: c.user_id == ^user_id,
        order_by: [asc: c.time]
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
end
