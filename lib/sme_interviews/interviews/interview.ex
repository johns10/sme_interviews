defmodule SMEInterviews.Interviews.Interview do
  use Ecto.Schema
  import Ecto.Changeset

  schema "interviews" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(interview, attrs) do
    interview
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
