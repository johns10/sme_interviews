defmodule SmeInterviewsWeb.InterviewLive.Show do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.Interviews
  alias SmeInterviews.Interviews.Interview
  alias SmeInterviews.Questions
  alias SmeInterviews.Questions.Question
  alias SmeInterviews.Answers
  alias SmeInterviews.Answers.Answer
  alias SmeInterviews.ChatMessages.ChatMessage
  alias SmeInterviews.InterviewUsers
  alias SmeInterviews.InterviewUsers.InterviewUser
  alias SmeInterviewsWeb.ChatMessageLive.ChatBar
  alias SmeInterviewsWeb.InterviewUserLive.ListComponent

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    SmeInterviewsWeb.Endpoint.subscribe("interview:#{id}")

    {:ok,
     socket
     |> assign(:active_question_id, nil)
     |> assign(:main_span, 3)
     |> assign(:sidebar_span, 0)
     |> assign(:return_to, Routes.interview_show_path(socket, :show, id)),
     layout: {SmeInterviewsWeb.LayoutView, "empty.html"}}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    interview = Interviews.get_complete_interview!(id)
    SmeInterviewsWeb.Endpoint.subscribe("interview:#{interview.id}")

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, action, %{"id" => id}) when action in [:edit, :edit_users] do
    interview = Interviews.get_complete_interview!(id)

    case Bodyguard.permit(Interviews, :update_interview, socket.assigns.current_user, interview) do
      :ok ->
        socket
        |> assign(:page_title, "Edit Interview")
        |> assign(:interview, interview)

      {:error, _} ->
        socket
        |> push_patch(to: socket.assigns.return_to)
        |> put_flash(:error, "You are not permitted to perform this action")
    end
  end

  def apply_action(socket, :show, %{"id" => id}) do
    interview = Interviews.get_complete_interview!(id)

    case Bodyguard.permit(Interviews, :show_interview, socket.assigns.current_user, interview) do
      :ok ->
        socket
        |> assign(:page_title, "Show Interview")
        |> assign(:interview, interview)

      {:error, _} ->
        socket
        |> push_patch(to: Routes.interview_index_path(socket, :index))
        |> put_flash(:error, "You are not permitted to view this interview")
    end
  end

  @impl true
  def handle_info(
        %{event: "update", payload: %Interview{name: name, description: description}},
        socket
      ) do
    interview =
      socket.assigns.interview
      |> Map.put(:name, name)
      |> Map.put(:description, description)

    {:noreply, assign(socket, :interview, interview)}
  end

  def handle_info(%{payload: %Interview{}}, socket), do: {:noreply, socket}

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

  def handle_info(%{event: "create", payload: %ChatMessage{} = message}, socket) do
    send_update(self(), ChatBar, id: "chat", chat_message: message)
    {:noreply, socket}
  end

  def handle_info(%{event: "create", payload: %InterviewUser{} = interview_user}, socket) do
    send_update(self(), ListComponent, id: "interview-user-list", create: interview_user)
    {:noreply, socket}
  end

  def handle_info(%{event: "delete", payload: %InterviewUser{} = interview_user}, socket) do
    send_update(self(), ListComponent, id: "interview-user-list", delete: interview_user)
    {:noreply, socket}
  end

  def handle_info({:email, _}, socket), do: {:noreply, socket}

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

  def handle_event("delete-interview-user", %{"id" => id}, socket) do
    interview_user = InterviewUsers.get_interview_user!(id)
    {:ok, _} = InterviewUsers.delete_interview_user(interview_user)

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

  def can_update_interview?(user, interview) do
    case Bodyguard.permit(Interviews, :update_interview, user, interview) do
      :ok -> true
      {:error, _} -> false
    end
  end

  defp page_title(:show), do: "Show Interview"
  defp page_title(:edit_users), do: "Edit Interview"
  defp page_title(:edit), do: "Edit Interview"
end
