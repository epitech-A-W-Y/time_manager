
defmodule TimeManager.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add_if_not_exists :role, :string, default: "employee", null: false
    end
  end
end
