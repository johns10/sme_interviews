defmodule SmeInterviewsWeb.Router do
  use SmeInterviewsWeb, :router

  import SmeInterviewsWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SmeInterviewsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :set_color_scheme
    plug :set_owasp_headers
  end

  defp set_owasp_headers(conn, _opts) do
    conn
    |> put_resp_header("content-security-policy", "default-src 'self'; script-src 'self' 'unsafe-eval'; connect-src 'self'; img-src 'self' data: https:; style-src 'self' 'unsafe-inline';base-uri 'self';form-action 'self'")
    |> put_resp_header("referrer-policy", "strict-origin-when-cross-origin")
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env() in [:dev, :test] do
    scope "/", SmeInterviewsWeb do
      pipe_through :browser
      # live_dashboard "/dashboard", metrics: SmeInterviewsWeb.Telemetry

      # get "/", PageController, :index

      # live "/interviews", InterviewLive.Index, :index
      # live "/interviews/new", InterviewLive.Index, :new
      # live "/interviews/:id/edit", InterviewLive.Index, :edit

      # live "/interviews/:id", InterviewLive.Show, :show
      # live "/interviews/:id/show/edit", InterviewLive.Show, :edit

      live "/interview_users", InterviewUserLive.Index, :index
      live "/interview_users/new", InterviewUserLive.Index, :new
      live "/interview_users/:id/edit", InterviewUserLive.Index, :edit

      live "/interview_users/:id", InterviewUserLive.Show, :show
      live "/interview_users/:id/show/edit", InterviewUserLive.Show, :edit

      live "/questions", QuestionLive.Index, :index
      live "/questions/new", QuestionLive.Index, :new
      live "/questions/:id/edit", QuestionLive.Index, :edit

      live "/questions/:id", QuestionLive.Show, :show
      live "/questions/:id/show/edit", QuestionLive.Show, :edit

      live "/answers", AnswerLive.Index, :index
      live "/answers/new", AnswerLive.Index, :new
      live "/answers/:id/edit", AnswerLive.Index, :edit

      live "/answers/:id", AnswerLive.Show, :show
      live "/answers/:id/show/edit", AnswerLive.Show, :edit

      live "/chat_message", ChatMessageLive.Index, :index
      live "/chat_message/new", ChatMessageLive.Index, :new
      live "/chat_message/:id/edit", ChatMessageLive.Index, :edit

      live "/chat_message/:id", ChatMessageLive.Show, :show
      live "/chat_message/:id/show/edit", ChatMessageLive.Show, :edit
    end
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", SmeInterviewsWeb do
    pipe_through [:browser]

    get "/", PageController, :index
  end

  scope "/", SmeInterviewsWeb do
    pipe_through [:browser, :require_authenticated_user]
  end

  scope "/", SmeInterviewsWeb do
    pipe_through [:browser, :require_authenticated_user, :require_confirmed_user]

    live "/interviews", InterviewLive.Index, :index
    live "/interviews/new", InterviewLive.Index, :new
    live "/interviews/:id/edit", InterviewLive.Index, :edit

    live "/interviews/:id", InterviewLive.Show, :show
    live "/interviews/:id/edit_users", InterviewLive.Show, :edit_users
    live "/interviews/:id/show/edit", InterviewLive.Show, :edit
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
  end

  # Use this plug to set a "dark" css class on <html> element
  defp set_color_scheme(conn, _opts) do
    color_scheme = conn.cookies["color-scheme"] || "dark"

    conn
    |> assign(:color_scheme, color_scheme)
    |> put_session(:color_scheme, color_scheme)
  end

  ## Authentication routes

  scope "/", SmeInterviewsWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", SmeInterviewsWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", SmeInterviewsWeb do
    pipe_through [:browser]

    get "/users/invitation/:token", UserInvitationController, :edit
    post "/users/invitation/:token", UserInvitationController, :update
    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
