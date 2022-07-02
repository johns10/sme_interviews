defmodule SMEInterviewsWeb.AnswerLive.Show do
  use SMEInterviewsWeb, :live_view

  alias SMEInterviews.Answers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:answer, Answers.get_answer!(id))}
  end

  defp page_title(:show), do: "Show Answer"
  defp page_title(:edit), do: "Edit Answer"
end
