defmodule SmeInterviewsWeb.AnswerLive.Index do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.Answers
  alias SmeInterviews.Answers.Answer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :answers, list_answers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Answer")
    |> assign(:answer, Answers.get_answer!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Answer")
    |> assign(:answer, %Answer{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Answers")
    |> assign(:answer, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    answer = Answers.get_answer!(id)
    {:ok, _} = Answers.delete_answer(answer)

    {:noreply, assign(socket, :answers, list_answers())}
  end

  defp list_answers do
    Answers.list_answers()
  end
end
