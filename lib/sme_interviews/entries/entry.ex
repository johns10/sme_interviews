defmodule SmeInterviews.Entries.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: false}
  @timestamps_opts [type: :naive_datetime_usec]
  @derive {Jason.Encoder, only: [:id, :from, :text, :to, :interview_id, :get_url, :status]}
  schema "entries" do
    field :from, :naive_datetime
    field :text, :string
    field :to, :naive_datetime
    field :interview_id, :id
    field :get_url, :string, virtual: true

    field :status, Ecto.Enum,
      values: [
        :started,
        :ended,
        :interim_transcription,
        :transcription_started,
        :transcription_complete
      ]

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:id, :from, :to, :text, :status])
    |> foreign_key_constraint(:interview_id)
  end
end
