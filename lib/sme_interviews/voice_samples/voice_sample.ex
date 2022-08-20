defmodule SmeInterviews.VoiceSamples.VoiceSample do
  use SmeInterviews.Schema
  import Ecto.Changeset

  alias SmeInterviews.Accounts.User

  schema "voice_samples" do
    field :text, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(voice_sample, attrs) do
    voice_sample
    |> cast(attrs, [:text, :user_id])
    |> validate_required([:text])
    |> foreign_key_constraint(:user_id)
  end
end
