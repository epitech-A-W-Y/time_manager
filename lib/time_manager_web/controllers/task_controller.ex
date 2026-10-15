defmodule TimeManagerWeb.TaskController do
  use TimeManagerWeb, :controller

  def index(conn, _params) do
    json(conn, %{message: "Tasks are not part of Time Manager"})
  end
end
