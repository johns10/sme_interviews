defmodule SMEInterviewsWeb.InterviewLive.Show do
  use SMEInterviewsWeb, :live_view

  alias SMEInterviews.Interviews
  alias SMEInterviews.Questions
  alias SMEInterviews.Questions.Question
  alias SMEInterviews.Answers
  alias SMEInterviews.Answers.Answer
  alias SMEInterviews.ChatMessages.ChatMessage

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    SMEInterviewsWeb.Endpoint.subscribe("interview:#{id}")

    {:ok,
     socket
     |> assign(:active_question_id, nil)
     |> assign(:main_span, 3)
     |> assign(:sidebar_span, 0)}
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

  def handle_info(%{event: "create", payload: %ChatMessage{question_id: question_id} = chat_message}, socket) do
    send_update(self(), SMEInterviewsWeb.ChatMessageLive.ChatBar, id: "chat", chat_message: chat_message)
    {:noreply, socket}
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
    {:noreply,
     push_patch(socket, to: Routes.interview_show_path(socket, :show, socket.assigns.interview))}
  end

  def handle_event("open-chat", %{"id" => id}, socket) do
    {:noreply, socket |> assign(:active_question_id, String.to_integer(id))}
  end

  def handle_event("close-chat", _, socket) do
    {:noreply, socket |> assign(:active_question_id, nil)}
  end

  defp page_title(:show), do: "Show Interview"
  defp page_title(:edit), do: "Edit Interview"
end
