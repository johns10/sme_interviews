defmodule SmeInterviewsWeb.InterviewTemplateLive.FormComponent do
  use SmeInterviewsWeb, :live_component

  alias SmeInterviews.InterviewTemplates

  @impl true
  def update(%{interview_template: interview_template} = assigns, socket) do
    changeset = InterviewTemplates.change_interview_template(interview_template)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"interview_template" => interview_template_params}, socket) do
    changeset =
      socket.assigns.interview_template
      |> InterviewTemplates.change_interview_template(interview_template_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"interview_template" => interview_template_params}, socket) do
    save_interview_template(socket, socket.assigns.action, interview_template_params)
  end

  defp save_interview_template(socket, :edit, interview_template_params) do
    case InterviewTemplates.update_interview_template(
           socket.assigns.interview_template,
           interview_template_params
         ) do
      {:ok, _interview_template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Interview template updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_interview_template(socket, :new, interview_template_params) do
    case InterviewTemplates.create_interview_template(interview_template_params) do
      {:ok, _interview_template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Interview template created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
