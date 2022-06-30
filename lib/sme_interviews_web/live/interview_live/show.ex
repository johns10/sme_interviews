defmodule SMEInterviewsWeb.InterviewLive.Show do
  use SMEInterviewsWeb, :live_view

  alias SMEInterviews.Interviews

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:interview, Interviews.get_interview!(id))}
  end

  defp page_title(:show), do: "Show Interview"
  defp page_title(:edit), do: "Edit Interview"
end
