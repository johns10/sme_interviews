defmodule SMEInterviewsWeb.ChatMessageLive.InlineFormComponentNew do
  use SMEInterviewsWeb, :live_component

  import SMEInterviewsWeb.ChatMessageLive.FormHandlers

  @impl true
  def update(assigns, socket) do
    update_socket(assigns, socket)
  end

  @impl true
  def handle_event("validate", %{"chat_message" => chat_message_params}, socket) do
    validate(chat_message_params, socket)
  end

  def handle_event("save", %{"chat_message" => chat_message_params}, socket) do
    save_no_redirect(socket, :new, chat_message_params)
  end
end
