defmodule SmeInterviewsWeb.InterviewTemplateLive.Index do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.InterviewTemplates
  alias SmeInterviews.InterviewTemplates.InterviewTemplate

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: user}} = socket) do
    {:ok, assign(socket, :interview_templates, list_interview_templates(user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Interview template")
    |> assign(:interview_template, InterviewTemplates.get_interview_template!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Interview template")
    |> assign(:interview_template, %InterviewTemplate{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Interview templates")
    |> assign(:interview_template, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    interview_template = InterviewTemplates.get_interview_template!(id)
    {:ok, _} = InterviewTemplates.delete_interview_template(interview_template)
    templates = list_interview_templates(socket.assigns.current_user.id)

    {:noreply, assign(socket, :interview_templates, templates)}
  end

  defp list_interview_templates(user_id) do
    InterviewTemplates.list_interview_templates(filters: [user_id: user_id])
  end
end
