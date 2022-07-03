defmodule SMEInterviewsWeb.ChatMessageLive.ChatBar do
  use SMEInterviewsWeb, :live_component

  alias SMEInterviews.ChatMessages

  @impl true
  def update(%{active_question_id: question_id} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:chat_message_collection, list_chat_message(question_id))}
  end
  def update(%{chat_message: chat_message} = assigns, socket) do
    current_messages = socket.assigns.chat_message_collection
    updated_messages = safe_create(current_messages, chat_message)
    {:ok, socket |> assign(:chat_message_collection, updated_messages)}
  end

  defp list_chat_message(nil), do: []

  defp list_chat_message(question_id) do
    [filters: [question_id: question_id]]
    |> ChatMessages.list_chat_message()
  end
end
