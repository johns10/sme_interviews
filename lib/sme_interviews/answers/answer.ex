defmodule SmeInterviews.Answers.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  alias SmeInterviews.Questions.Question

  schema "answers" do
    field :body, :string
    field :order, :integer
    field :selected, :boolean, default: false

    belongs_to :question, Question

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:body, :order, :selected, :question_id])
    |> validate_required([:body, :selected])
    |> foreign_key_constraint(:question_id)
  end
end
