defmodule SmeInterviews.Entries.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: false}
  @timestamps_opts [type: :naive_datetime_usec]
  schema "entries" do
    field :from, :naive_datetime
    field :text, :string
    field :to, :naive_datetime
    field :interview_id, :id
    field :get_url, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:id, :from, :to, :text])
    |> foreign_key_constraint(:interview_id)
  end
end
