
defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated_api do
    plug TimeManagerWeb.Plugs.AuthPlug
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    # Public authentication routes
    post "/users/sign_up", UserController, :sign_up
    post "/users/sign_in", UserController, :sign_in

    # Authenticated routes
    pipe_through :authenticated_api

    post "/users/sign_out", UserController, :sign_out

    get "/clocks/:user_id", ClockController, :index
    post "/clocks/:user_id", ClockController, :create

    get "/workingtime/:user_id", WorkingTimeController, :index
    get "/workingtime/:user_id/:id", WorkingTimeController, :show
    post "/workingtime/:user_id", WorkingTimeController, :create
    put "/workingtime/:id", WorkingTimeController, :update
    delete "/workingtime/:id", WorkingTimeController, :delete
  end

  if Application.compile_env(:time_manager, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
