defmodule SmeInterviews.VoiceSamplesTest do
  use SmeInterviews.DataCase

  alias SmeInterviews.VoiceSamples

  describe "voice_samples" do
    alias SmeInterviews.VoiceSamples.VoiceSample

    import SmeInterviews.VoiceSamplesFixtures

    @invalid_attrs %{text: nil}

    test "list_voice_samples/0 returns all voice_samples" do
      voice_sample = voice_sample_fixture()
      assert VoiceSamples.list_voice_samples() == [voice_sample]
    end

    test "get_voice_sample!/1 returns the voice_sample with given id" do
      voice_sample = voice_sample_fixture()

      assert VoiceSamples.get_voice_sample!(voice_sample.id) ==
               voice_sample
    end

    test "create_voice_sample/1 with valid data creates a voice_sample" do
      valid_attrs = %{text: "some text"}

      assert {:ok, %VoiceSample{} = voice_sample} = VoiceSamples.create_voice_sample(valid_attrs)

      assert voice_sample.text == "some text"
    end

    test "create_voice_sample/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = VoiceSamples.create_voice_sample(@invalid_attrs)
    end

    test "update_voice_sample/2 with valid data updates the voice_sample" do
      voice_sample = voice_sample_fixture()
      update_attrs = %{text: "some updated text"}

      assert {:ok, %VoiceSample{} = voice_sample} =
               VoiceSamples.update_voice_sample(voice_sample, update_attrs)

      assert voice_sample.text == "some updated text"
    end

    test "update_voice_sample/2 with invalid data returns error changeset" do
      voice_sample = voice_sample_fixture()

      assert {:error, %Ecto.Changeset{}} =
               VoiceSamples.update_voice_sample(voice_sample, @invalid_attrs)

      assert voice_sample ==
               VoiceSamples.get_voice_sample!(voice_sample.id)
    end

    test "delete_voice_sample/1 deletes the voice_sample" do
      voice_sample = voice_sample_fixture()

      assert {:ok, %VoiceSample{}} = VoiceSamples.delete_voice_sample(voice_sample)

      assert_raise Ecto.NoResultsError, fn ->
        VoiceSamples.get_voice_sample!(voice_sample.id)
      end
    end

    test "change_voice_sample/1 returns a voice_sample changeset" do
      voice_sample = voice_sample_fixture()

      assert %Ecto.Changeset{} = VoiceSamples.change_voice_sample(voice_sample)
    end
  end
end
