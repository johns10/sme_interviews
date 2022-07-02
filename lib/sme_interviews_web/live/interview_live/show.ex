defmodule SMEInterviewsWeb.InterviewLive.Show do
  use SMEInterviewsWeb, :live_view

  alias SMEInterviews.Interviews
  alias SMEInterviews.Questions
  alias SMEInterviews.Questions.Question
  alias SMEInterviews.Answers
  alias SMEInterviews.Answers.Answer

  @impl true
  def mount(_params, _session, socket) do
    SMEInterviewsWeb.Endpoint.subscribe("interview:1")
    {:ok,
    socket
    |> assign(:active_chat, nil)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    interview = Interviews.get_complete_interview!(id)
    SMEInterviewsWeb.Endpoint.subscribe("interview:#{interview.id}")

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:interview, interview)}
  end

  @impl true
  def handle_info(%{event: "create", payload: %Question{} = question}, socket) do
    question = Map.put(question, :answers, [])
    questions = safe_create(socket.assigns.interview.questions, question)
    interview = Map.put(socket.assigns.interview, :questions, questions)
    {:noreply, assign(socket, :interview, interview)}
  end

  def handle_info(%{event: "update", payload: %Question{} = question}, socket) do
    questions = safe_update(socket.assigns.interview.questions, question)
    interview = Map.put(socket.assigns.interview, :questions, questions)
    {:noreply, assign(socket, :interview, interview)}
  end

  def handle_info(%{event: "delete", payload: %Question{} = question}, socket) do
    questions = socket.assigns.interview.questions |> Enum.filter(&(&1.id != question.id))
    interview = Map.put(socket.assigns.interview, :questions, questions)
    {:noreply, assign(socket, :interview, interview)}
  end

  def handle_info(%{event: "create", payload: %Answer{question_id: question_id} = answer}, socket) do
    questions =
      socket.assigns.interview.questions
      |> Enum.map(fn question ->
        if question.id == question_id do
          Map.put(question, :answers, safe_create(question.answers, answer))
        else
          question
        end
      end)

    interview = Map.put(socket.assigns.interview, :questions, questions)
    {:noreply, assign(socket, :interview, interview)}
  end

  def handle_info(%{event: "update", payload: %Answer{question_id: question_id} = answer}, socket) do
    questions =
      socket.assigns.interview.questions
      |> Enum.map(fn question ->
        if question.id == question_id do
          Map.put(question, :answers, safe_update(question.answers, answer))
        else
          question
        end
      end)

    interview = Map.put(socket.assigns.interview, :questions, questions)
    {:noreply, assign(socket, :interview, interview)}
  end

  def handle_info(%{event: "delete", payload: %Answer{question_id: question_id} = answer}, socket) do
    questions =
      socket.assigns.interview.questions
      |> Enum.map(fn question ->
        if question.id == question_id do
          Map.put(question, :answers, Enum.filter(question.answers, &(&1.id != answer.id)))
        else
          question
        end
      end)

    interview = Map.put(socket.assigns.interview, :questions, questions)

    {:noreply, assign(socket, :interview, interview)}
  end

  @impl true
  def handle_event("delete-answer", %{"id" => id}, socket) do
    answer = Answers.get_answer!(id)
    {:ok, _} = Answers.delete_answer(answer)

    {:noreply, socket}
  end

  def handle_event("delete-question", %{"id" => id}, socket) do
    question = Questions.get_question!(id)
    {:ok, _} = Questions.delete_question(question)

    {:noreply, socket}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: Routes.interview_show_path(socket, :show, socket.assigns.interview))}
  end

  def layout(%{active_chat: thing} = assigns) do
    ~H"""
    <div class="grid grid-cols-3">
      <div class="col-span-2">
        <%= render_slot(@inner_block) %>
      </div>
      <div class="col-span-1">
        <.live_component
          module={SMEInterviewsWeb.ChatMessageLive.ChatBar}
          id="chat"
        />
      </div>
    </div>
    """
  end

  def layout(%{active_chat: nil} = assigns) do
    ~H"""
    <div class="grid grid-cols-3">
      <div class="col-span-3">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp page_title(:show), do: "Show Interview"
  defp page_title(:edit), do: "Edit Interview"
end
