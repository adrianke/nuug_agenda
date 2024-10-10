defmodule NuugAgendaWeb.Router do
  use NuugAgendaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authed do
    plug NuugAgendaWeb.EnsureLoggedIn
  end

  scope "/", NuugAgendaWeb do
    pipe_through :browser

    get "/log_in", LogInController, :new
    post "/log_in", LogInController, :create
    get "/log_in/key/:key", LogInController, :create
    get "/logout", LogInController, :logout

    scope "/" do
      pipe_through :authed

      get "/", IndexController, :index

      get "/votes", VoteController, :index
      get "/votes/export", VoteController, :export
      get "/votes/:proposal_id", VoteController, :show
      post "/votes/cast", VoteController, :cast_vote

      get "/agenda", AgendaController, :index
      get "/agenda/:talk_request_id/respond", AgendaController, :respond
      get "/agenda/new", AgendaController, :new
      post "/agenda", AgendaController, :create
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", NuugAgendaWeb do
  #   pipe_through :api
  # end
end
