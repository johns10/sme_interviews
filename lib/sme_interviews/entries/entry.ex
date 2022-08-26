defmodule SmeInterviews.Entries.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :from, :naive_datetime
    field :text, :string
    field :to, :naive_datetime
    field :interview_id, :id

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:from, :to, :text])
    |> validate_required([:from, :to, :text])
    |> foreign_key_constraint(:interview_id)
  end
end
