defmodule TimeManager.Repo.Migrations.EnsureRoleOnUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string, null: false, default: "employee"
    end
  end
end
