defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Users
  alias TimeManager.User

  def index(conn, params) do
    users = Users.list_users(params)
    render(conn, :index, users: users)
  end

  def create(conn, params) do
    case Users.create_user(params) do
      {:ok, %User{} = user} ->
        conn
        |> put_status(:created)
        |> render(:show, user: user)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerWeb.ChangesetJSON, :error, changeset: changeset)
    end
  end

  def register(conn, params) do
    params = Map.put(params, "role", "employee")

    changeset =
      %User{}
      |> User.changeset(params)
      |> Ecto.Changeset.validate_required([:password])

    case Ecto.Changeset.apply_action(changeset, :insert) do
      {:ok, _user_data} ->
        case Users.create_user(params) do
          {:ok, %User{} = user} ->
            conn
            |> put_status(:created)
            |> render(:show, user: user)

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(TimeManagerWeb.ChangesetJSON, :error, changeset: changeset)
        end

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerWeb.ChangesetJSON, :error, changeset: changeset)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Users.list_users(%{"email" => email}) do
      [%User{password_hash: hash} = user] when is_binary(hash) ->
        if Argon2.verify_pass(password, hash) do
          conn
          |> put_status(:ok)
          |> render(:show, user: user)
        else
          unauthorized(conn)
        end

      _ ->
        unauthorized(conn)
    end
  end

  def login(conn, _params) do
    unauthorized(conn)
  end

  def show(conn, %{"id" => id}) do
    case Users.get_user(id) do
      nil ->
        send_resp(conn, :not_found, "")

      user ->
        render(conn, :show, user: user)
    end
  end

  def update(conn, %{"id" => id} = params) do
    user = Users.get_user!(id)
    user_params = Map.delete(params, "id")

    case Users.update_user(user, user_params) do
      {:ok, %User{} = user} ->
        render(conn, :show, user: user)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerWeb.ChangesetJSON, :error, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    case Users.delete_user(user) do
      {:ok, %User{}} ->
        send_resp(conn, :no_content, "")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerWeb.ChangesetJSON, :error, changeset: changeset)
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Invalid email or password"})
  end
end