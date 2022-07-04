defmodule SmeInterviewsWeb.PageLive do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="py-2" />
    <.h2>Welcome to SME Interviews</.h2>
    <%= if @current_user.confirmed_at do %>
      <.p>You haven't confirmed your user. You'll need to do so before you can use the app.</.p>
      <.p>You'll need to confirm your user before you can use the App.</.p>
    <% else %>
      <.p>Click the "Interviews" button above to get started!</.p>
    <% end %>
    """
  end
end
