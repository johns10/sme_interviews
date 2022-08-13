defmodule SmeInterviewsWeb.InterviewTemplateLive.DescriptionFormComponent do
  use SmeInterviewsWeb, :live_component
  import SmeInterviewsWeb.InterviewTemplateLive.FormHandlers

  @impl true
  def update(assigns, socket), do: update_socket(assigns, socket)

  @impl true
  def handle_event("save", %{"interview_template" => params}, socket),
    do: save_no_redirect(socket, socket.assigns.action, params)
end
