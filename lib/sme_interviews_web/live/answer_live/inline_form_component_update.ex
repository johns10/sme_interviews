defmodule SMEInterviewsWeb.AnswerLive.InlineFormComponentUpdate do
  use SMEInterviewsWeb, :live_component

  import SMEInterviewsWeb.AnswerLive.FormHandlers

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
