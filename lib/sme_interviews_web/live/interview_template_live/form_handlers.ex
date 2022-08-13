defmodule SmeInterviewsWeb.InterviewTemplateLive.FormHandlers do
  import Phoenix.LiveView
  alias SmeInterviews.InterviewTemplates

  def update_socket(%{interview_template: interview_template} = assigns, socket) do
    changeset = InterviewTemplates.change_interview_template(interview_template)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  def validate(params, socket) do
    changeset =
      socket.assigns.interview_template
      |> InterviewTemplates.change_interview_template(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def save_no_redirect(socket, :edit, interview_template_params) do
    case InterviewTemplates.update_interview_template(
           socket.assigns.interview_template,
           interview_template_params
         ) do
      {:ok, _interview_template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Interview template updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def save_no_redirect(socket, :new, interview_template_params) do
    case InterviewTemplates.create_interview_template(interview_template_params) do
      {:ok, _interview_template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Interview template created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
