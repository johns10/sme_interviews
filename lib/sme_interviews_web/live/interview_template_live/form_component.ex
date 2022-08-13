defmodule SmeInterviewsWeb.InterviewTemplateLive.FormComponent do
  use SmeInterviewsWeb, :live_component

  import SmeInterviewsWeb.InterviewTemplateLive.FormHandlers
  alias SmeInterviews.InterviewTemplates

  @impl true
  def update(assigns, socket), do: update_socket(assigns, socket)

  @impl true
  def handle_event("validate", %{"interview_template" => interview_params}, socket),
    do: validate(interview_params, socket)

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
