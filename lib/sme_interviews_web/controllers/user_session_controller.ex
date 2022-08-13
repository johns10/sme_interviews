defmodule SmeInterviewsWeb.UserSessionController do
  use SmeInterviewsWeb, :controller

  alias SmeInterviews.Accounts
  alias SmeInterviewsWeb.UserAuth


  def new(conn, %{"zoom_auth_code" => zoom_auth_code}) do
    conn
    |> assign(:zoom_auth_code, zoom_auth_code)
    |> do_new()
  end
  def new(conn, _params), do: conn |> assign_defaults() |> do_new()

  def create(conn, %{"user" => %{"zoom_auth_code" => zoom_auth_code} = user_params}) do
    get_token(zoom_auth_code, "")
    |> IO.inspect()

    conn
    |> do_create(Map.delete(user_params, "zoom_auth_code"))
  end
  def create(conn, %{"user" => user_params}) do
    do_create(conn, user_params)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end

  defp do_new(conn) do
    render(conn, "new.html", error_message: nil)
  end

  defp do_create(conn, %{"email" => email, "password" => password} = params) do
    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> assign_defaults
      |> render("new.html", error_message: "Invalid email or password")
    end
  end

  defp assign_defaults(conn), do: conn |> assign(:zoom_auth_code, "")

  #

  defp get_token(code, verifier) do
    conf =
      Application.get_env(:sme_interviews, SmeInterviews.Zoom)
      |> Enum.into(%{})

    IO.inspect(conf)
    redirect_uri = conf.redirect_uri
    %{
      code: code,
      verifier: verifier,
      redirect_uri: redirect_uri,
      grant_type: "authorization_code"
    }
    |> token_request()
  end

  defp token_request(params, id \\ nil, secret \\ nil) do
    conf =
      Application.get_env(:sme_interviews, SmeInterviews.Zoom)
      |> Enum.into(%{})

    username = id || conf.client_id
    password = secret || conf.client_secret
    base_url = conf.host

    HTTPoison.post(
      base_url <> "/oauth/token",
      "",
      [
        {"content-type", "application/x-www-form-urlencoded"},
        {"authorization",  "Basic #{username} #{password}"}
      ],
      params: params
    )
  end
end
