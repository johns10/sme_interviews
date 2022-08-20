defmodule SmeInterviews.VoiceSamplesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SmeInterviews.VoiceSamples` context.
  """

  @doc """
  Generate a voice_sample.
  """
  def voice_sample_fixture(attrs \\ %{}) do
    {:ok, voice_sample} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> SmeInterviews.VoiceSamples.create_voice_sample()

    voice_sample
  end
end
