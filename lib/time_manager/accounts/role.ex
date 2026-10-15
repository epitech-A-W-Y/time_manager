defmodule TimeManager.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :label, :string

    has_many :users, TimeManager.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:label])
    |> validate_required([:label])
    |> unique_constraint(:label)
  end
end
