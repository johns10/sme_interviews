defmodule SmeInterviews.QuestionTemplates.QuestionTemplate do
  use SmeInterviews.Schema
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
    |> cast(attrs, [:interview_template_id, :body])
    |> foreign_key_constraint(:interview_template_id)
    |> validate_required([:body])
  end
end
