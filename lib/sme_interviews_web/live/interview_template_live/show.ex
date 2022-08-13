defmodule SmeInterviewsWeb.InterviewTemplateLive.Show do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.InterviewTemplates
  alias SmeInterviews.QuestionTemplates.QuestionTemplate
  alias SmeInterviews.QuestionTemplates

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: {SmeInterviewsWeb.LayoutView, "empty.html"}}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    SmeInterviewsWeb.Endpoint.subscribe("interview_template:#{id}")

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:interview_template, InterviewTemplates.get_complete_interview_template!(id))}
  end

  @impl true
  def handle_info(%{event: "create", payload: %QuestionTemplate{} = question_template}, socket) do
    question_templates =
      safe_create(socket.assigns.interview_template.question_templates, question_template)

    interview_template =
      Map.put(socket.assigns.interview_template, :question_templates, question_templates)

    {:noreply, assign(socket, :interview_template, interview_template)}
  end

  def handle_info(%{event: "update", payload: %QuestionTemplate{} = question_template}, socket) do
    question_templates =
      safe_update(socket.assigns.interview_template.question_templates, question_template)

    interview_template =
      Map.put(socket.assigns.interview_template, :question_templates, question_templates)

    {:noreply, assign(socket, :interview_template, interview_template)}
  end

  def handle_info(%{event: "delete", payload: %QuestionTemplate{} = question_template}, socket) do
    question_templates =
      socket.assigns.interview_template.question_templates
      |> Enum.filter(&(&1.id != question_template.id))

    interview_template =
      Map.put(socket.assigns.interview_template, :question_templates, question_templates)

    {:noreply, assign(socket, :interview_template, interview_template)}
  end

  @impl true
  def handle_event("delete-question_template", %{"id" => id}, socket) do
    question_template = QuestionTemplates.get_question_template!(id)
    {:ok, _} = QuestionTemplates.delete_question_template(question_template)

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Interview template"
  defp page_title(:edit), do: "Edit Interview template"
end
