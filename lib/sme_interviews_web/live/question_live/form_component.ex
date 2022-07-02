defmodule SMEInterviewsWeb.QuestionLive.FormComponent do
  use SMEInterviewsWeb, :live_component

  import SMEInterviewsWeb.QuestionLive.FormHandlers
  alias SMEInterviews.Questions

  @impl true
  def update(assigns, socket) do
    update_socket(assigns, socket)
  end

  @impl true
  def handle_event("validate", %{"question" => question_params}, socket) do
    validate(question_params, socket)
  end

  def handle_event("save", %{"question" => question_params}, socket) do
    save_question(socket, socket.assigns.action, question_params)
  end


  defp save_question(socket, :edit, question_params) do
    case Questions.update_question(socket.assigns.question, question_params) do
      {:ok, _question} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_question(socket, :new, question_params) do
    case Questions.create_question(question_params) do
      {:ok, _question} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
