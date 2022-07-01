defmodule SMEInterviewsWeb.Router do
  use SMEInterviewsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SMEInterviewsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :set_color_scheme
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SMEInterviewsWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/live", PageLive, :index
    live "/live/modal/:size", PageLive, :modal
    live "/live/slide_over/:origin", PageLive, :slide_over
    live "/live/pagination/:page", PageLive, :pagination
  end

  if Mix.env() in [:dev, :test] do
    scope "/", SMEInterviewsWeb do
      pipe_through :browser
      # live_dashboard "/dashboard", metrics: SMEInterviewsWeb.Telemetry

      live "/interviews", InterviewLive.Index, :index
      live "/interviews/new", InterviewLive.Index, :new
      live "/interviews/:id/edit", InterviewLive.Index, :edit

      live "/interviews/:id", InterviewLive.Show, :show
      live "/interviews/:id/show/edit", InterviewLive.Show, :edit

      live "/questions", QuestionLive.Index, :index
      live "/questions/new", QuestionLive.Index, :new
      live "/questions/:id/edit", QuestionLive.Index, :edit

      live "/questions/:id", QuestionLive.Show, :show
      live "/questions/:id/show/edit", QuestionLive.Show, :edit
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # Use this plug to set a "dark" css class on <html> element
  defp set_color_scheme(conn, _opts) do
    color_scheme = conn.cookies["color-scheme"] || "dark"

    conn
    |> assign(:color_scheme, color_scheme)
    |> put_session(:color_scheme, color_scheme)
  end
end
