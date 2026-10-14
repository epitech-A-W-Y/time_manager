defmodule TimeManager.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string

    field :role, Ecto.Enum,
      values: [:employee, :manager, :hr, :admin],
      default: :employee

    field :hashed_password, :string, redact: true
    field :password, :string, virtual: true, redact: true

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/^[^@\s]+@[^@\s]+\.[^@\s]+$/)
    |> unique_constraint(:email)
  end

  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      password when is_binary(password) and changeset.valid? ->
        put_change(
          changeset,
          :hashed_password,
          Argon2.hash_pwd_salt(password)
        )

      _ ->
        changeset
    end
  end
end
