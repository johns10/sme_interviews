defmodule SmeInterviewsWeb.AnswerLive.FormComponent do
  use SmeInterviewsWeb, :live_component

  import SmeInterviewsWeb.AnswerLive.FormHandlers
  alias SmeInterviews.Answers

  @impl true
  def update(assigns, socket), do: update_socket(assigns, socket)

  @impl true
  def handle_event("validate", %{"answer" => answer_params}, socket), do: validate(answer_params, socket)

  def handle_event("save", %{"answer" => answer_params}, socket) do
    save_answer(socket, socket.assigns.action, answer_params)
  end

  defp save_answer(socket, :edit, answer_params) do
    case Answers.update_answer(socket.assigns.answer, answer_params) do
      {:ok, _answer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Answer updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_answer(socket, :new, answer_params) do
    case Answers.create_answer(answer_params) do
      {:ok, _answer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Answer created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
