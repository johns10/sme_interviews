defmodule SmeInterviewsWeb.AnswerLive.FormHandlers do
  import Phoenix.LiveView
  alias SmeInterviews.Answers

  def update_socket(%{answer: answer} = assigns, socket) do
    changeset = Answers.change_answer(answer)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  def validate(params, socket) do
    changeset =
      socket.assigns.answer
      |> Answers.change_answer(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def save_no_redirect(socket, :edit, answer_params) do
    case Answers.update_answer(socket.assigns.answer, answer_params) do
      {:ok, _answer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Answer updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def save_no_redirect(socket, :new, answer_params) do
    case Answers.create_answer(answer_params) do
      {:ok, answer} ->
        changeset = Answers.change_answer(answer)
        {:noreply,
         socket
         |> put_flash(:info, "Answer created successfully")
         |> assign(:changeset, changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
