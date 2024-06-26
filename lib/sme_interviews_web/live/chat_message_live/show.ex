defmodule SmeInterviewsWeb.ChatMessageLive.Show do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.ChatMessages

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:chat_message, ChatMessages.get_chat_message!(id))}
  end

  defp page_title(:show), do: "Show Chat message"
  defp page_title(:edit), do: "Edit Chat message"
end
