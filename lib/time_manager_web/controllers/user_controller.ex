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
        |> render(
          TimeManagerWeb.ChangesetJSON,
          :error,
          changeset: changeset
        )
    end
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
        |> render(
          TimeManagerWeb.ChangesetJSON,
          :error,
          changeset: changeset
        )
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
        |> render(
          TimeManagerWeb.ChangesetJSON,
          :error,
          changeset: changeset
        )
    end
  end
end
