defmodule SmeInterviewsWeb.QuestionTemplateLive.InlineFormComponentUpdate do
  use SmeInterviewsWeb, :live_component

  import SmeInterviewsWeb.QuestionTemplateLive.FormHandlers

  @impl true
  def update(assigns, socket) do
    update_socket(assigns, socket)
  end

  @impl true
  def handle_event("validate", %{"question_template" => params}, socket) do
    validate(params, socket)
  end

  def handle_event("save", %{"question_template" => params}, socket) do
    save_no_redirect(socket, :edit, params)
  end
end
