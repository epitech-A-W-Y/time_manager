defmodule TimeManager.Repo.Migrations.AddPasswordToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add_if_not_exists :password_hash, :string
    end
  end
end
