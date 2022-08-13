defmodule SmeInterviewsWeb.QuestionTemplateLive.FormComponent do
  use SmeInterviewsWeb, :live_component

  import SmeInterviewsWeb.QuestionTemplateLive.FormHandlers
  alias SmeInterviews.QuestionTemplates

  @impl true
  def update(assigns, socket) do
    update_socket(assigns, socket)
  end

  @impl true
  def handle_event("validate", %{"question_template" => params}, socket) do
    validate(params, socket)
  end

  def handle_event("save", %{"question_template" => question_template_params}, socket) do
    save_question_template(socket, socket.assigns.action, question_template_params)
  end

  defp save_question_template(socket, :edit, question_template_params) do
    case QuestionTemplates.update_question_template(
           socket.assigns.question_template,
           question_template_params
         ) do
      {:ok, _question_template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question template updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_question_template(socket, :new, question_template_params) do
    case QuestionTemplates.create_question_template(question_template_params) do
      {:ok, _question_template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question template created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
