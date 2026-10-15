defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api
    post "/users/sign_up", UserController, :sign_up
    post "/users/sign_in", UserController, :sign_in
    resources "/users", UserController, except: [:new, :edit]
    get "/clocks/:user_id", ClockController, :index
    post "/clocks/:user_id", ClockController, :create
    get "/workingtime/:user_id", WorkingTimeController, :index
    get "/workingtime/:user_id/:id", WorkingTimeController, :show
    post "/workingtime/:user_id", WorkingTimeController, :create
    put "/workingtime/:id", WorkingTimeController, :update
    delete "/workingtime/:id", WorkingTimeController, :delete
  end
end
