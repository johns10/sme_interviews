defmodule SMEInterviewsWeb.ChatMessageLive.ChatBar do
  use SMEInterviewsWeb, :live_component

  alias SMEInterviews.ChatMessages
  alias SMEInterviews.ChatMessages.ChatMessage

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
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
