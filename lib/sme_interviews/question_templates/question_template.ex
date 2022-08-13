defmodule SmeInterviews.QuestionTemplates.QuestionTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  alias SmeInterviews.InterviewTemplates.InterviewTemplate

  schema "question_templates" do
    field :body, :string

    belongs_to :interview_template, InterviewTemplate

    timestamps()
  end

  @doc false
  def changeset(question_template, attrs) do
    question_template
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
