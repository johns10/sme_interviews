defmodule SmeInterviewsWeb.InterviewTemplateLive.Show do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.InterviewTemplates

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:interview_template, InterviewTemplates.get_interview_template!(id))}
  end

  defp page_title(:show), do: "Show Interview template"
  defp page_title(:edit), do: "Edit Interview template"
end
