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

  scope "/", PresencyWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/posts", PostController
    resources "/comments", CommentController
    resources "/users", UserController
    resources "/categories", CategoryController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PresencyWeb do
  #   pipe_through :api
  # end
end
