defmodule TimeManager.Repo.Migrations.UpdateUsersForTimeManager do
  use Ecto.Migration

  def change do
    rename table(:users), :first_name, to: :username
    rename table(:users), :last_name, to: :email
  end
end
