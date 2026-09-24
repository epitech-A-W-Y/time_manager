defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Clocks
  alias TimeManager.Clock

  def index(conn, %{"user_id" => user_id}) do
    clocks = Clocks.list_clocks(user_id)

    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"user_id" => user_id, "clock" => clock_params}) do
    clock_params = Map.put(clock_params, "user_id", user_id)

    with {:ok, %Clock{} = clock} <-
           Clocks.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> render(:show, clock: clock)
    end
  end
end
