defmodule SMEInterviewsWeb.ChatMessageLive.FormComponent do
  use SMEInterviewsWeb, :live_component

  alias SMEInterviews.ChatMessages

  @impl true
  def update(%{chat_message: chat_message} = assigns, socket) do
    changeset = ChatMessages.change_chat_message(chat_message)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"chat_message" => chat_message_params}, socket) do
    changeset =
      socket.assigns.chat_message
      |> ChatMessages.change_chat_message(chat_message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"chat_message" => chat_message_params}, socket) do
    save_chat_message(socket, socket.assigns.action, chat_message_params)
  end

  defp save_chat_message(socket, :edit, chat_message_params) do
    case ChatMessages.update_chat_message(socket.assigns.chat_message, chat_message_params) do
      {:ok, _chat_message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Chat message updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_chat_message(socket, :new, chat_message_params) do
    case ChatMessages.create_chat_message(chat_message_params) do
      {:ok, _chat_message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Chat message created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
