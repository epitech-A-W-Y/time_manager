defmodule TodolistWeb.TaskController do
  use TodolistWeb, :controller

  alias Todolist.Tasks
  alias Todolist.Task
  alias Todolist.Users

  action_fallback TodolistWeb.FallbackController

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, :index, tasks: tasks)
  end

  def create(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- Tasks.create_task(task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tasks/#{task}")
      |> render(:show, task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, :show, task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    with {:ok, %Task{} = task} <- Tasks.update_task(task, task_params) do
      render(conn, :show, task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)

    with {:ok, %Task{}} <- Tasks.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end

  def user_tasks(conn, %{"idUser" => id_user}) do
    case Users.get_user!(id_user) do
      %Todolist.User{} ->
        tasks = Tasks.list_tasks_by_user(id_user)
        render(conn, :index, tasks: tasks)
    end
  end
end