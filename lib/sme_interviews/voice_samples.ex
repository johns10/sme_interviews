defmodule SmeInterviews.VoiceSamples do
  @moduledoc """
  The VoiceSamples context.
  """

  import Ecto.Query, warn: false
  alias SmeInterviews.Repo

  alias SmeInterviews.VoiceSamples.VoiceSample

  def list_voice_samples do
    Repo.all(VoiceSample)
  end

  def get_voice_sample!(id), do: Repo.get!(VoiceSample, id)

  def create_voice_sample(attrs \\ %{}) do
    %VoiceSample{}
    |> VoiceSample.changeset(attrs)
    |> Repo.insert()
  end

  def update_voice_sample(%VoiceSample{} = voice_sample, attrs) do
    voice_sample
    |> VoiceSample.changeset(attrs)
    |> Repo.update()
  end

  def delete_voice_sample(%VoiceSample{} = voice_sample) do
    Repo.delete(voice_sample)
  end

  def change_voice_sample(%VoiceSample{} = voice_sample, attrs \\ %{}) do
    VoiceSample.changeset(voice_sample, attrs)
  end
end
