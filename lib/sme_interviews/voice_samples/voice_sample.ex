defmodule SmeInterviews.VoiceSamples.VoiceSample do
  use SmeInterviews.Schema
  import Ecto.Changeset

  alias SmeInterviews.Accounts.User

  schema "voice_samples" do
    field :text, :string
    field :aws_path, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(voice_sample, attrs) do
    voice_sample
    |> cast(attrs, [:text, :user_id, :aws_path])
    |> validate_required([:text])
    |> validate_change(:aws_path, fn
      :aws_path, "error" -> [aws_path: "Failed to upload file"]
      :aws_path, _ -> []
    end)
    |> foreign_key_constraint(:user_id)
  end
end
