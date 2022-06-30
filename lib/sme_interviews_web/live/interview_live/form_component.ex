defmodule SMEInterviewsWeb.InterviewLive.FormComponent do
  use SMEInterviewsWeb, :live_component

  alias SMEInterviews.Interviews

  @impl true
  def update(%{interview: interview} = assigns, socket) do
    changeset = Interviews.change_interview(interview)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"interview" => interview_params}, socket) do
    changeset =
      socket.assigns.interview
      |> Interviews.change_interview(interview_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"interview" => interview_params}, socket) do
    save_interview(socket, socket.assigns.action, interview_params)
  end

  defp save_interview(socket, :edit, interview_params) do
    case Interviews.update_interview(socket.assigns.interview, interview_params) do
      {:ok, _interview} ->
        {:noreply,
         socket
         |> put_flash(:info, "Interview updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_interview(socket, :new, interview_params) do
    case Interviews.create_interview(interview_params) do
      {:ok, _interview} ->
        {:noreply,
         socket
         |> put_flash(:info, "Interview created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
