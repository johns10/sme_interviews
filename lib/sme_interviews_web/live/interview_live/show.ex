defmodule SMEInterviewsWeb.InterviewLive.Show do
  use SMEInterviewsWeb, :live_view

  alias SMEInterviews.Interviews
  alias SMEInterviews.Questions.Question

  @impl true
  def mount(_params, _session, socket) do
    SMEInterviewsWeb.Endpoint.subscribe("interview:1")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    interview = Interviews.get_interview!(id) |> Interviews.preload_interview([:questions])
    SMEInterviewsWeb.Endpoint.subscribe("interview:#{interview.id}")
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:interview, interview)}
  end

  @impl true
  def handle_info(%{event: "create", payload: %Question{} = question}, socket) do
    questions = safe_create(socket.assigns.interview.questions, question)
    interview = Map.put(socket.assigns.interview, :questions, questions)
    {:noreply, assign(socket, :interview, interview)}
  end
  def handle_info(%{event: "update", payload: %Question{} = question}, socket) do
    questions = safe_update(socket.assigns.interview.questions, question)
    interview = Map.put(socket.assigns.interview, :questions, questions)
    {:noreply, assign(socket, :interview, interview)}
  end

  defp safe_create(items, item) do
    Enum.reduce(items, false, fn inner_item, acc ->
      acc || inner_item.id == item.id
    end)
    |> case do
      true -> items
      false -> items ++ [item]
    end
  end

  defp safe_update(items, item) do
    Enum.map(items, fn inner_item ->
      if inner_item.id == item.id do
        item
      else
        inner_item
      end
    end)
  end

  defp page_title(:show), do: "Show Interview"
  defp page_title(:edit), do: "Edit Interview"
end
