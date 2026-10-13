defmodule TimeManager.Repo.Migrations.AddAuthenticationToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password_hash, :string
      add :xsrf_token, :string
      add :role, :string, default: "User"
    end
  end
end
