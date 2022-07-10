defmodule SmeInterviewsWeb.InterviewUserLive.InlineFormComponent do
  use SmeInterviewsWeb, :live_component
  import SmeInterviewsWeb.InterviewUserLive.FormHandlers

  alias SmeInterviews.Accounts
  alias SmeInterviews.Accounts.User
  alias SmeInterviews.InterviewUsers
  alias SmeInterviews.InterviewUsers.InterviewUserForm

  @impl true
  def update(assigns, socket) do
    update_socket(assigns, socket)
  end

  @impl true
  def handle_event("validate", %{"interview_user_form" => interview_user_params}, socket) do
    validate(interview_user_params, socket)
  end

  def handle_event("save", %{"interview_user_form" => params}, socket) do
    with {:form, {:ok, result}} <- {:form, InterviewUsers.create_interview_user_form(params)},
         %InterviewUserForm{email: email, interview_id: interview_id} <- result,
         {:ok, %User{id: id}} <- upsert_user(email, socket) do

      interview_user_params = %{user_id: id, interview_id: interview_id}
      save_no_redirect(socket, socket.assigns.action, interview_user_params)
    else
      {:form, {:error, form_changeset}} ->
        {:noreply, assign(socket, :form_changeset, form_changeset)}
    end
  end

  defp upsert_user(email, %{assigns: %{current_user: user}} = socket) do
    Accounts.get_user_by_email(email)
    |> case do
      %User{} = user -> {:ok, user}
      nil ->
        case Accounts.invite_user(%{email: email, invited_by_user_id: user.id}) do
          {:ok, user} ->
            Accounts.deliver_user_invitation_instructions(
              user,
              &Routes.user_invitation_url(socket, :edit, &1)
            )

            {:ok, user}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:error, changeset}
        end
    end
  end
end
