defmodule CounterWeb.Router do
  use CounterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CounterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CounterWeb do
    pipe_through :browser

    #get "/", PageController, :home

    live("/", Counter)
  end

  # Other scopes may use custom stacks.
  # scope "/api", CounterWeb do
  #   pipe_through :api
  # end
end
