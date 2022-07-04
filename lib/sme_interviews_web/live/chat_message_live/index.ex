defmodule SmeInterviewsWeb.ChatMessageLive.Index do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.ChatMessages
  alias SmeInterviews.ChatMessages.ChatMessage

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :chat_message_collection, list_chat_message())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Chat message")
    |> assign(:chat_message, ChatMessages.get_chat_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Chat message")
    |> assign(:chat_message, %ChatMessage{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Chat message")
    |> assign(:chat_message, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    chat_message = ChatMessages.get_chat_message!(id)
    {:ok, _} = ChatMessages.delete_chat_message(chat_message)

    {:noreply, assign(socket, :chat_message_collection, list_chat_message())}
  end

  defp list_chat_message do
    ChatMessages.list_chat_message()
  end
end
