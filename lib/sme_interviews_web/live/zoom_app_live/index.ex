defmodule SmeInterviewsWeb.ZoomAppLive.Index do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.Accounts.UserToken

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: user}} = socket) do
    socket =
      UserToken.user_and_contexts_query(user, ["zoom"])
      |> SmeInterviews.Repo.all()
      |> case do
        [] -> false
          socket
          |> push_event("authorize_zoom_user", %{})
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

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  @impl true
end
