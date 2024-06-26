defmodule SmeInterviewsWeb.AnswerLive.InlineFormComponentUpdate do
  use SmeInterviewsWeb, :live_component

  import SmeInterviewsWeb.AnswerLive.FormHandlers

  @impl true
  def update(assigns, socket) do
    update_socket(assigns, socket)
  end

  @impl true
  def handle_event("validate", %{"answer" => answer_params}, socket) do
    validate(answer_params, socket)
  end

  def handle_event("save", %{"answer" => answer_params}, socket) do
    save_no_redirect(socket, :edit, answer_params)
  end
end
