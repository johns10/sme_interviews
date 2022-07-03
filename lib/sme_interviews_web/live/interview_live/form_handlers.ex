defmodule SmeInterviewsWeb.InterviewLive.FormHandlers do
  import Phoenix.LiveView
  alias SmeInterviews.Interviews

  def update_socket(%{interview: interview} = assigns, socket) do
    changeset = Interviews.change_interview(interview)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  def validate(params, socket) do
    changeset =
      socket.assigns.interview
      |> Interviews.change_interview(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def save_no_redirect(socket, :edit, question_params) do
    case Interviews.update_interview(socket.assigns.interview, question_params) do
      {:ok, _interview} ->
        {:noreply,
         socket
         |> put_flash(:info, "Interview updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def save_no_redirect(socket, :new, question_params) do
    case Interviews.create_interview(question_params) do
      {:ok, _interview} ->
        {:noreply,
         socket
         |> put_flash(:info, "Interview created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
