defmodule SmeInterviewsWeb.InterviewLive.Index do
  use SmeInterviewsWeb, :live_view

  alias SmeInterviews.Interviews
  alias SmeInterviews.Interviews.Interview

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:interviews, list_interviews())
      |> assign(:return_to, Routes.interview_index_path(socket, :index))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Interview")
    |> assign(:interview, Interviews.get_interview!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Interview")
    |> assign(:interview, %Interview{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Interviews")
    |> assign(:interview, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    interview = Interviews.get_interview!(id)
    {:ok, _} = Interviews.delete_interview(interview)

    {:noreply, assign(socket, :interviews, list_interviews())}
  end
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end

  defp list_interviews do
    Interviews.list_interviews()
  end
end
