defmodule SmeInterviews.InterviewTemplates.InterviewTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  alias SmeInterviews.Accounts.User

  schema "interview_templates" do
    field :description, :string
    field :name, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(interview_template, attrs) do
    interview_template
    |> cast(attrs, [:description, :name])
    |> validate_required([:name])
  end
end
