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

    user ->
      password_valid =
        valid_password?(password, user.password_hash) or
          valid_password?(password, user.hashed_password)

      if password_valid do
        {:ok, Repo.preload(user, :role)}
      else
        {:error, :invalid_credentials}
      end
  end
end

  defp valid_password?(_password, nil), do: false

  defp valid_password?(password, hash) when is_binary(hash) do
    cond do
      String.starts_with?(hash, "$argon2") ->
        Argon2.verify_pass(password, hash)

      String.starts_with?(hash, ["$2a$", "$2b$", "$2y$"]) ->
        Bcrypt.verify_pass(password, hash)

      true ->
        false
    end
  end

  defp valid_password?(_password, _hash), do: false

end
