defmodule SmeInterviews.InterviewUsers.InterviewUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias SmeInterviews.Interviews.Interview
  alias SmeInterviews.Accounts.User

  schema "interview_users" do

    belongs_to :interview, Interview
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(interview_user, attrs) do
    interview_user
    |> cast(attrs, [:user_id, :interview_id])
    |> validate_required([:user_id, :interview_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:interview_id)
  end
end
