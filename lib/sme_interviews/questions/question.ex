defmodule SMEInterviews.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias SMEInterviews.Interviews.Interview

  schema "questions" do
    field :body, :string
    field :status, Ecto.Enum, values: [:open, :closed, :cancelled]

    belongs_to :interview, Interview

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:body, :status])
    |> validate_required([:body, :status])
  end
end
