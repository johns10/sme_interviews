defmodule SmeInterviewsWeb.InterviewUserLive.Index do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.InterviewUsers
  alias SmeInterviews.InterviewUsers.InterviewUser

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
      |> assign(:interview_users, list_interview_users())
      |> assign(:return_to, Routes.interview_index_path(socket, :index))}
    end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Interview user")
    |> assign(:interview_user, InterviewUsers.get_interview_user!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Interview user")
    |> assign(:interview_user, %InterviewUser{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Interview users")
    |> assign(:interview_user, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    interview_user = InterviewUsers.get_interview_user!(id)
    {:ok, _} = InterviewUsers.delete_interview_user(interview_user)

    {:noreply, assign(socket, :interview_users, list_interview_users())}
  end


  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end

  defp list_interview_users do
    InterviewUsers.list_interview_users()
  end
end
