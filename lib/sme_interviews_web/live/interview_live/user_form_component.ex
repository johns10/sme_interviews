defmodule SmeInterviewsWeb.InterviewLive.UserFormComponent do
  use SmeInterviewsWeb, :live_component
  import SmeInterviewsWeb.InterviewLive.FormHandlers

  @impl true
  def update(assigns, socket), do: update_socket(assigns, socket)

  @impl true
  def handle_event("validate", %{"interview" => interview_params}, socket), do: validate(interview_params, socket)

  def handle_event("save", %{"interview" => interview_params}, socket) do
    save_redirect(socket, socket.assigns.action, interview_params)
  end
end
