defmodule SmeInterviewsWeb.InterviewLive.Index do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.Interviews
  alias SmeInterviews.Interviews.Interview

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: user}} = socket) do
    {
      :ok,
      socket
      |> assign(:return_to, Routes.interview_index_path(socket, :index))
      |> assign(:interviews, list_interviews(user.id))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    interview = Interviews.get_interview!(id)
    case Bodyguard.permit(Interviews, :update_interview, socket.assigns.current_user, interview) do
      :ok ->
        socket
        |> assign(:page_title, "Edit Interview")
        |> assign(:interview, interview)
      {:error, :unauthorized} ->
        socket
        |> push_patch(to: socket.assigns.return_to)
        |> put_flash(:error, "You are not permitted to perform this action")
    end
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

    {:noreply, assign(socket, :interviews, list_interviews(socket.assigns.current_user.id))}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end

  defp list_interviews(user_id) do
    Interviews.list_interviews(filters: [user_id: user_id])
  end
end
