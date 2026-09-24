defmodule TimeManagerWeb.UserJSON do
  alias TimeManager.User

  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  def data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email
    }
  end
end
