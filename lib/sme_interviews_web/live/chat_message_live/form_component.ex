defmodule SMEInterviewsWeb.ChatMessageLive.FormComponent do
  use SMEInterviewsWeb, :live_component
  import SMEInterviewsWeb.ChatMessageLive.FormHandlers
  alias SMEInterviews.ChatMessages

  @impl true
  def update(assigns, socket), do: update_socket(assigns, socket)

  @impl true
  def handle_event("validate", %{"chat_message" => chat_message_params}, socket),
    do: validate(chat_message_params, socket)

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
