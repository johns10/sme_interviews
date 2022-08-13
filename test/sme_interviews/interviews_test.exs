defmodule SmeInterviews.InterviewsTest do
  use SmeInterviews.DataCase

  alias SmeInterviews.Interviews
  alias SmeInterviews.InterviewTemplatesFixtures

  describe "interviews" do
    alias SmeInterviews.Interviews.Interview

    import SmeInterviews.InterviewsFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_interviews/0 returns all interviews" do
      interview = interview_fixture()
      assert Interviews.list_interviews() == [interview]
    end

    test "get_interview!/1 returns the interview with given id" do
      interview = interview_fixture()
      assert Interviews.get_interview!(interview.id) == interview
    end

    test "create_interview/1 with valid data creates a interview" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Interview{} = interview} = Interviews.create_interview(valid_attrs)
      assert interview.description == "some description"
      assert interview.name == "some name"
    end

    test "create_interview/1 with an interview template creates an interview" do
      assert {:ok, %Interview{} = interview} =
               InterviewTemplatesFixtures.interview_template_fixture()
               |> Map.put(:question_templates, [])
               |> Interviews.create_interview()

      assert interview.description == "some description"
      assert interview.name == "some name"
    end

    test "create_interview/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Interviews.create_interview(@invalid_attrs)
    end

    test "update_interview/2 with valid data updates the interview" do
      interview = interview_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Interview{} = interview} =
               Interviews.update_interview(interview, update_attrs)

      assert interview.description == "some updated description"
      assert interview.name == "some updated name"
    end

    test "update_interview/2 with invalid data returns error changeset" do
      interview = interview_fixture()
      assert {:error, %Ecto.Changeset{}} = Interviews.update_interview(interview, @invalid_attrs)
      assert interview == Interviews.get_interview!(interview.id)
    end

    test "delete_interview/1 deletes the interview" do
      interview = interview_fixture()
      assert {:ok, %Interview{}} = Interviews.delete_interview(interview)
      assert_raise Ecto.NoResultsError, fn -> Interviews.get_interview!(interview.id) end
    end

    test "change_interview/1 returns a interview changeset" do
      interview = interview_fixture()
      assert %Ecto.Changeset{} = Interviews.change_interview(interview)
    end
  end
end
