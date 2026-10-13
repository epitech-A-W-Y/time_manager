defmodule TimeManager.Accounts do
  alias TimeManager.Repo
  alias TimeManager.Accounts.User

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      nil ->
        {:error, :invalid_credentials}

      %User{password_hash: nil} ->
        {:error, :invalid_credentials}

      user ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          {:ok, Repo.preload(user, :role)}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end
