defmodule SMEInterviewsWeb.AnswerLive.ListComponent do
  use SMEInterviewsWeb, :live_component

  @impl true
  def update(%{question: question} = assigns, socket) do
    SMEInterviewsWeb.Endpoint.subscribe("question:#{question.id}")
    {:ok,
     socket
     |> assign(assigns)}
  end

  def sort(answers) do
    answers
    |> Enum.sort(& &1.inserted_at > &2.inserted_at)
    |> Enum.sort(& &1.selected > &2.selected)
  end
end
