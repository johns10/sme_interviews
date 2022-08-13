defmodule SmeInterviewsWeb.QuestionTemplateLive.Index do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.QuestionTemplates
  alias SmeInterviews.QuestionTemplates.QuestionTemplate

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :question_template_collection, list_question_template())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Question template")
    |> assign(:question_template, QuestionTemplates.get_question_template!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Question template")
    |> assign(:question_template, %QuestionTemplate{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Question template")
    |> assign(:question_template, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    question_template = QuestionTemplates.get_question_template!(id)
    {:ok, _} = QuestionTemplates.delete_question_template(question_template)

    {:noreply, assign(socket, :question_template_collection, list_question_template())}
  end

  defp list_question_template do
    QuestionTemplates.list_question_template()
  end
end
