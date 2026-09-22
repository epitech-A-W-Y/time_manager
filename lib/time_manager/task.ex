defmodule Todolist.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :status, :string
    belongs_to :user, Todolist.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
  |> cast(attrs, [:title, :description, :status, :user_id])
    |> validate_required([:title, :description, :status])
  end
end
