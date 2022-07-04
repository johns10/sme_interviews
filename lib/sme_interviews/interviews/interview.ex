defmodule SmeInterviews.Interviews.Interview do
  use Ecto.Schema
  import Ecto.Changeset
  alias SmeInterviews.Questions.Question
  alias SmeInterviews.Accounts.User

  schema "interviews" do
    field :description, :string
    field :name, :string

    belongs_to :user, User

    has_many :questions, Question

    timestamps()
  end

  @doc false
  def changeset(interview, attrs) do
    interview
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
