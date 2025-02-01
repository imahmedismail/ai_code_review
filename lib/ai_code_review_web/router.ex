defmodule AiCodeReviewWeb.Router do
  use AiCodeReviewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AiCodeReviewWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AiCodeReviewWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/reviews", CodeReviewLive.Index, :index
    live "/reviews/new", CodeReviewLive.Index, :new
    live "/reviews/:id/edit", CodeReviewLive.Index, :edit

    live "/reviews/:id", CodeReviewLive.Show, :show
    live "/reviews/:id/show/edit", CodeReviewLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", AiCodeReviewWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ai_code_review, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AiCodeReviewWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
