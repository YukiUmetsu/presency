defmodule PresencyWeb.Router do
  use PresencyWeb, :router

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

  pipeline :frontend do
    plug PresencyWeb.Plugs.LoadUser
    plug PresencyWeb.Plugs.Locale
  end

  pipeline :admin do
    plug PresencyWeb.Plugs.AdminLayout
    plug PresencyWeb.Plugs.LoadAdmin
  end

  scope "/", PresencyWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  #--- Not Authenticated Admin---#
  scope "/admin", PresencyWeb.Admin, as: :admin do
    pipe_through [:browser, :admin]

    get "/login", SessionController, :new
    post "/sendlink", SessionController, :send_link
    get "/magiclink", SessionController, :create
  end

  scope "/admin", PresencyWeb.Admin, as: :admin do
    pipe_through [:browser, :admin, PresencyWeb.Plugs.AuthenticateAdmin]

    get "/", DashboardController, :show
    resources "/users", UserController
    resources "/admin_users", AdminUserController
    resources "/posts", PostController
    resources "/comments", CommentController
    resources "/categories", CategoryController

    get "/logout", SessionController, :delete
  end


  # Other scopes may use custom stacks.
  # scope "/api", PresencyWeb do
  #   pipe_through :api
  # end
end
