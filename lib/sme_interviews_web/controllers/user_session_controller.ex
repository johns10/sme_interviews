defmodule SmeInterviewsWeb.UserSessionController do
  use SmeInterviewsWeb, :controller

  alias SmeInterviews.Accounts
  alias SmeInterviewsWeb.UserAuth

  def new(conn, %{"app" => app}) do
    conn
    |> assign(:app, app)
    |> render("new_redirect.html", error_message: nil)
  end

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => %{"app" => "zoom"} = user_params}) do
    conn
    |> put_session(:user_return_to, Routes.zoom_app_index_path(conn, :index))
    |> create_user(user_params)
  end
  def create(conn, %{"user" => user_params}), do: create_user(conn, user_params)

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end

  def create_user(conn, %{"email" => email, "password" => password} = params) do
    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end
end
