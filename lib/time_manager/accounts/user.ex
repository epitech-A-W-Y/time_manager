defmodule TimeManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :xsrf_token, :string
field :hashed_password, :string, redact: true
field :legacy_role, :string, source: :role, default: "employee"
    field :password, :string, virtual: true

belongs_to :role, TimeManager.Accounts.Role
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :username,
      :email,
      :password,
      :password_hash,
      :xsrf_token,
      :role_id
    ])
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(Map.put_new(attrs, :role_id, 1))
    |> validate_required([:username, :password])
    |> validate_length(:username, min: 1, max: 50)
    |> validate_length(:email, max: 255)
    |> validate_length(:password, min: 8, max: 72, count: :bytes)
    |> put_password_hash()
  end
  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
        |> delete_change(:password)
    end
  end
end
