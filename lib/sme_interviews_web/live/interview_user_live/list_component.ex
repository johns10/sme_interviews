defmodule SmeInterviewsWeb.InterviewUserLive.ListComponent do
  use SmeInterviewsWeb, :live_component

  alias SmeInterviews.InterviewUsers
  alias SmeInterviews.InterviewUsers.InterviewUser

  @impl true
  def update(%{interview_id: interview_id} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:interview_user_collection, list_interview_user(interview_id))}
  end
  def update(%{create: interview_user}, socket) do
    interview_users = socket.assigns.interview_user_collection
    updated_interview_users = safe_create(interview_users, interview_user)
    {:ok, socket |> assign(:interview_user_collection, updated_interview_users)}
  end
  def update(%{delete: interview_user}, socket) do
    interview_users = socket.assigns.interview_user_collection
    updated_interview_users = Enum.filter(interview_users, fn iu -> iu.id != interview_user.id end)
    {:ok, socket |> assign(:interview_user_collection, updated_interview_users)}
  end

  defp list_interview_user(nil), do: []

  defp list_interview_user(interview_id) do
    [filters: [interview_id: interview_id], preloads: [:user]]
    |> InterviewUsers.list_interview_users()
  end
end
