defmodule SmeInterviewsWeb.InterviewUserLive.FormHandlers do
  import Phoenix.LiveView

  alias SmeInterviews.InterviewUsers
  alias SmeInterviews.InterviewUsers.InterviewUserForm

  def update_socket(%{interview_user: interview_user} = assigns, socket) do
    changeset = InterviewUsers.change_interview_user(interview_user)
    form_changeset = InterviewUsers.change_interview_user_form(%InterviewUserForm{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:form_changeset, form_changeset)}
  end

  def validate(params, socket) do
    form_changeset = validate_interview_user_form(params)
    {:noreply, assign(socket, :form_changeset, form_changeset)}
  end

  def validate_interview_user_form(params) do
    %InterviewUserForm{}
      |> InterviewUsers.change_interview_user_form(params)
      |> Map.put(:action, :validate)
  end

  def save_with_redirect(socket, :edit, interview_user_params) do
    case InterviewUsers.update_interview_user(socket.assigns.interview_user, interview_user_params) do
      {:ok, _interview_user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Interview user updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def save_with_redirect(socket, :new, interview_user_params) do
    case InterviewUsers.create_interview_user(interview_user_params) do
      {:ok, _interview_user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Interview user created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def save_no_redirect(socket, :edit, interview_user_params) do
    case InterviewUsers.update_interview_user(socket.assigns.interview_user, interview_user_params) do
      {:ok, interview_user} ->
        changeset = InterviewUsers.change_interview_user(interview_user)
        form_changeset = InterviewUsers.change_interview_user_form(%InterviewUserForm{})
        {:noreply,
         socket
         |> put_flash(:info, "Interview user updated successfully")
         |> assign(:changeset, changeset)
         |> assign(:form_changeset, form_changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def save_no_redirect(socket, :new, interview_user_params) do
    case InterviewUsers.create_preloaded_interview_user(interview_user_params) do
      {:ok, interview_user} ->
        changeset = InterviewUsers.change_interview_user(interview_user)
        form_changeset = InterviewUsers.change_interview_user_form(%InterviewUserForm{})
        {:noreply,
         socket
         |> put_flash(:info, "Interview user created successfully")
         |> assign(:changeset, changeset)
         |> assign(:form_changeset, form_changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
