defmodule SmeInterviewsWeb.QuestionLive.InlineFormComponentUpdate do
  use SmeInterviewsWeb, :live_component

  import SmeInterviewsWeb.QuestionLive.FormHandlers

  @impl true
  def update(assigns, socket) do
    update_socket(assigns, socket)
  end

  @impl true
  def handle_event("validate", %{"question" => question_params}, socket) do
    validate(question_params, socket)
  end

  def handle_event("save", %{"question" => question_params}, socket) do
    save_no_redirect(socket, :edit, question_params)
  end
end
