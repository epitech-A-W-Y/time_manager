defmodule TimeManager.Repo.Migrations.EnsureRoleOnUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add_if_not_exists :role, :string, null: false, default: "employee"
    end
  end
end
