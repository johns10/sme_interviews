defmodule SmeInterviewsWeb.InterviewUserLive.FormComponent do
  use SmeInterviewsWeb, :live_component
  import SmeInterviewsWeb.InterviewUserLive.FormHandlers

  @impl true
  def update(assigns, socket) do
    update_socket(assigns, socket)
  end

  @impl true
  def handle_event("validate", %{"interview_user_form" => interview_user_params}, socket) do
    validate(interview_user_params, socket)
  end

  def handle_event("save", %{"interview_user_form" => interview_user_params}, socket) do
    validate_interview_user_form(interview_user_params)
    |> case do
      %{errors: []} -> save_with_redirect(socket, socket.assigns.action, interview_user_params)
      form_changeset -> {:noreply, assign(socket, :form_changeset, form_changeset)}
    end
  end
end
