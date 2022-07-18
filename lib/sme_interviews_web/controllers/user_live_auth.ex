defmodule SmeInterviewsWeb.UserLiveAuth do
  import Phoenix.LiveView

  alias SmeInterviews.Accounts

  def on_mount(:default, _params, session, socket) do
    socket = default_assigns(socket, session)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: SmeInterviewsWeb.Router.Helpers.user_registration_path(socket, :new))}
    end
  end

  def default_assigns(socket, %{"user_token" => token, "color_scheme" => color_scheme}),
    do: default_assigns(socket, %{"token" => token, "color_scheme" => color_scheme})

  def default_assigns(socket, %{"token" => token, "color_scheme" => color_scheme}) do
    socket
    |> assign_new(:current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
    |> assign(:color_scheme, color_scheme)
  end

  def default_assigns(socket, _) do
    socket
    |> assign(:color_scheme, nil)
    |> assign(:current_user, nil)
  end
end
