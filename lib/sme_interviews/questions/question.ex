defmodule SMEInterviews.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias SMEInterviews.Interviews.Interview

  @values [:open, :closed, :cancelled]
  def values(), do: @values
  def status_select_options, do: Enum.map(@values, & {to_string(&1), to_string(&1)})

  schema "questions" do
    field :body, :string
    field :status, Ecto.Enum, values: @values

    belongs_to :interview, Interview

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:body, :status, :interview_id])
    |> validate_required([:body, :status])
    |> foreign_key_constraint(:interview_id)
  end
end
