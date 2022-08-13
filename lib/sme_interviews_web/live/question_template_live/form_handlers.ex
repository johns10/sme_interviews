defmodule SmeInterviewsWeb.QuestionTemplateLive.FormHandlers do
  import Phoenix.LiveView

  alias SmeInterviews.QuestionTemplates

  def update_socket(%{question_template: question_template} = assigns, socket) do
    changeset = QuestionTemplates.change_question_template(question_template)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  def validate(params, socket) do
    changeset =
      socket.assigns.question_template
      |> QuestionTemplates.change_question_template(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def save_no_redirect(socket, :edit, question_template_params) do
    case QuestionTemplates.update_question_template(
           socket.assigns.question_template,
           question_template_params
         ) do
      {:ok, _question_template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question template updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def save_no_redirect(socket, :new, question_template_params) do
    case QuestionTemplates.create_question_template(question_template_params) do
      {:ok, _question_template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question template created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
