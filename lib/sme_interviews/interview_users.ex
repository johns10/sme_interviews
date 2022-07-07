defmodule SmeInterviews.InterviewUsers do
  @moduledoc """
  The InterviewUsers context.
  """

  import Ecto.Query, warn: false
  alias SmeInterviews.Repo

  alias SmeInterviews.InterviewUsers.InterviewUser
  alias SmeInterviews.InterviewUsers.InterviewUserForm

  def list_interview_users do
    Repo.all(InterviewUser)
  end

  def get_interview_user!(id), do: Repo.get!(InterviewUser, id)

  def create_interview_user(attrs \\ %{}) do
    %InterviewUser{}
    |> InterviewUser.changeset(attrs)
    |> Repo.insert()
  end

  def update_interview_user(%InterviewUser{} = interview_user, attrs) do
    interview_user
    |> InterviewUser.changeset(attrs)
    |> Repo.update()
  end

  def delete_interview_user(%InterviewUser{} = interview_user) do
    Repo.delete(interview_user)
  end

  def change_interview_user(%InterviewUser{} = interview_user, attrs \\ %{}) do
    InterviewUser.changeset(interview_user, attrs)
  end

  def change_interview_user_form(%InterviewUserForm{} = interview_user_form, attrs \\ %{}) do
    InterviewUserForm.changeset(interview_user_form, attrs)
  end
end
