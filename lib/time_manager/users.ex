defmodule TimeManager.Users do
  import Ecto.Query, warn: false

  alias TimeManager.Repo
  alias TimeManager.User

  def list_users(params \\ %{}) do
    User
    |> filter_by_email(params)
    |> filter_by_username(params)
    |> Repo.all()
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  defp filter_by_email(query, %{"email" => email}) do
    where(query, [u], u.email == ^email)
  end

  defp filter_by_email(query, _params) do
    query
  end

  defp filter_by_username(query, %{"username" => username}) do
    where(query, [u], u.username == ^username)
  end

  defp filter_by_username(query, _params) do
    query
  end
end
