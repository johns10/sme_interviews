defmodule SmeInterviewsWeb.ZoomAppLive.Index do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserConnectLive

  alias SmeInterviews.Accounts.UserToken
  alias SmeInterviews.Accounts.User

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: %User{} = user}} = socket) do
    socket =
      UserToken.user_and_contexts_query(user, ["zoom"])
      |> SmeInterviews.Repo.all()
      |> case do
        [] -> false
          socket
          |> assign(:zoom_connected?, false)
        [_token] ->
          socket
          |> push_event("configure_zoom_sdk", %{})
          |> assign(:zoom_connected?, true)
      end

    {
      :ok,
      socket
    }
  end

  def mount(_params, _session, socket) do
    {:ok, push_redirect(socket, to: Routes.user_session_path(socket, :new, %{"app" => "zoom"}))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  @impl true
  def handle_event("authorize", _, socket) do
    {:noreply, push_event(socket, "authorize_zoom_user", %{})}
  end
end
