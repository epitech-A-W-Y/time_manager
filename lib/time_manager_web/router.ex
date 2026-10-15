
defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated_api do
    plug :accepts, ["json"]
    plug TimeManagerWeb.AuthPlug
  end

  pipeline :admin_only do
    plug TimeManagerWeb.AdminPlug
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    post "/users/sign_up", UserController, :sign_up
    post "/users/sign_in", UserController, :sign_in
  end

  # Only admins can manage user accounts.
  scope "/api", TimeManagerWeb do
    pipe_through [:authenticated_api, :admin_only]

    resources "/users", UserController, except: [:new, :edit]
  end

  # Authenticated users can access these routes.
  # Ownership and manager permissions must also be enforced in controllers.
  scope "/api", TimeManagerWeb do
    pipe_through :authenticated_api

    get "/clocks/:user_id", ClockController, :index
    post "/clocks/:user_id", ClockController, :create

    get "/workingtime/:user_id", WorkingTimeController, :index
    get "/workingtime/:user_id/:id", WorkingTimeController, :show
    post "/workingtime/:user_id", WorkingTimeController, :create
    put "/workingtime/:id", WorkingTimeController, :update
    delete "/workingtime/:id", WorkingTimeController, :delete

  end
end

