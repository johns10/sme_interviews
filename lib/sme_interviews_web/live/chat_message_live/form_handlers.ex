defmodule SmeInterviewsWeb.ChatMessageLive.FormHandlers do
  import Phoenix.LiveView
  alias SmeInterviews.ChatMessages

  def update_socket(%{chat_message: chat_message} = assigns, socket) do
    changeset = ChatMessages.change_chat_message(chat_message)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  def validate(params, socket) do
    changeset =
      socket.assigns.chat_message
      |> ChatMessages.change_chat_message(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def save_no_redirect(socket, :edit, params) do
    case ChatMessages.update_chat_message(socket.assigns.chat_message, params) do
      {:ok, chat_message} ->
        changeset = ChatMessages.change_chat_message(chat_message)
        {:noreply,
         socket
         |> put_flash(:info, "Chat message updated successfully")
         |> assign(:changeset, changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end

  end

  def save_no_redirect(socket, :new, params) do
    case ChatMessages.create_chat_message(params) do
      {:ok, _chat_message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Chat message created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end

  end
end
