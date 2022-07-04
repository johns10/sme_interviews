defmodule SmeInterviewsWeb.UserLiveAuth do
  import Phoenix.LiveView

  alias SmeInterviews.Accounts
  def on_mount(:default, params, %{"user_token" => token, "color_scheme" => color_scheme}, socket),
    do: on_mount(:default, params, %{"token" => token, "color_scheme" => color_scheme}, socket)

  def on_mount(:default, _params, %{"token" => token, "color_scheme" => color_scheme} = _session, socket) do
    socket = assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
    |> assign(:color_scheme, color_scheme)

    if socket.assigns.current_user.confirmed_at do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: SmeInterviewsWeb.Router.Helpers.page_path(socket, :index))}
    end
  end

  def on_mount(:default, _params, _session, socket) do
    socket =
      socket
      |> assign(:color_scheme, nil)
      |> assign(:current_user, nil)

    {:halt, redirect(socket, to: SmeInterviewsWeb.Router.Helpers.user_registration_path(socket, :new))}
  end
end
