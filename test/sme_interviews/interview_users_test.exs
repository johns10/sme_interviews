defmodule SmeInterviews.InterviewUsersTest do
  use SmeInterviews.DataCase

  alias SmeInterviews.InterviewUsers

  describe "interview_users" do
    alias SmeInterviews.InterviewUsers.InterviewUser

    import SmeInterviews.InterviewUsersFixtures

    @invalid_attrs %{user_id: 1, interview_id: 1}

    test "list_interview_users/0 returns all interview_users" do
      interview_user = interview_user_fixture()
      assert InterviewUsers.list_interview_users() == [interview_user]
    end

    test "get_interview_user!/1 returns the interview_user with given id" do
      interview_user = interview_user_fixture()
      assert InterviewUsers.get_interview_user!(interview_user.id) == interview_user
    end

    test "create_interview_user/1 with valid data creates a interview_user" do
      valid_attrs = %{}

      assert {:ok, %InterviewUser{} = interview_user} = InterviewUsers.create_interview_user(valid_attrs)
    end

    test "create_interview_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = InterviewUsers.create_interview_user(@invalid_attrs)
    end

    test "update_interview_user/2 with valid data updates the interview_user" do
      interview_user = interview_user_fixture()
      update_attrs = %{}

      assert {:ok, %InterviewUser{} = interview_user} = InterviewUsers.update_interview_user(interview_user, update_attrs)
    end

    test "update_interview_user/2 with invalid data returns error changeset" do
      interview_user = interview_user_fixture()
      assert {:error, %Ecto.Changeset{}} = InterviewUsers.update_interview_user(interview_user, @invalid_attrs)
      assert interview_user == InterviewUsers.get_interview_user!(interview_user.id)
    end

    test "delete_interview_user/1 deletes the interview_user" do
      interview_user = interview_user_fixture()
      assert {:ok, %InterviewUser{}} = InterviewUsers.delete_interview_user(interview_user)
      assert_raise Ecto.NoResultsError, fn -> InterviewUsers.get_interview_user!(interview_user.id) end
    end

    test "change_interview_user/1 returns a interview_user changeset" do
      interview_user = interview_user_fixture()
      assert %Ecto.Changeset{} = InterviewUsers.change_interview_user(interview_user)
    end
  end
end
