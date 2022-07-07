defmodule SmeInterviews.InterviewUsers.InterviewUserForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do

    field :email, :string
    field :interview_id, :id

    timestamps()
  end

  @doc false
  def changeset(interview_user, attrs) do
    interview_user
    |> cast(attrs, [:email, :interview_id])
    |> validate_required([:email, :interview_id])
  end
end
