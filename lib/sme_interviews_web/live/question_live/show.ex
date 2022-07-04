defmodule SmeInterviewsWeb.QuestionLive.Show do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.Questions

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:return_to, Routes.interview_index_path(socket, :index))
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:question, Questions.get_question!(id))}
  end

  defp page_title(:show), do: "Show Question"
  defp page_title(:edit), do: "Edit Question"
end
