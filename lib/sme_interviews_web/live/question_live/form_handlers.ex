defmodule SmeInterviewsWeb.QuestionLive.FormHandlers do
  import Phoenix.LiveView
  alias SmeInterviews.Questions
  alias SmeInterviews.Questions.Question

  def update_socket(%{question: question} = assigns, socket) do
    changeset = Questions.change_question(question)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  def validate(params, socket) do
    changeset =
      socket.assigns.question
      |> Questions.change_question(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def save_no_redirect(socket, :edit, question_params) do
    case Questions.update_question(socket.assigns.question, question_params) do
      {:ok, _question} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def save_no_redirect(socket, :new, question_params) do
    case Questions.create_question(question_params) do
      {:ok, _question} ->
        changeset = Questions.change_question(%Question{})
        {:noreply,
         socket
         |> put_flash(:info, "Question created successfully")
         |> assign(:changeset, changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
