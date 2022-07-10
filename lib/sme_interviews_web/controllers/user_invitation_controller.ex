defmodule SmeInterviewsWeb.UserInvitationController do
  use SmeInterviewsWeb, :controller

  alias SmeInterviews.Accounts

  def edit(conn, %{"token" => token}) do
    render(conn, "edit.html", token: token)
  end

  def update(conn, %{"token" => token, "user" => %{"password" => password}}) do
    case Accounts.accept_invitation(token, password) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Invitation accepted.")
        |> redirect(to: "/")

      :error ->
        case conn.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: "/")

          %{} ->
            conn
            |> put_flash(:error, "User invitation link is invalid or it has expired.")
            |> redirect(to: "/")
        end
    end
  end
end
