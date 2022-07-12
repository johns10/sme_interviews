defmodule SmeInterviewsWeb.InterviewLiveSecurityTest do
  use SmeInterviewsWeb.ConnCase
  import Phoenix.LiveViewTest
  import SmeInterviews.InterviewsFixtures
  import SmeInterviews.AccountsFixtures

  setup :register_confirm_and_log_in_user

  defp create_other_user(_) do
    user = user_fixture()
    %{other_user: user}
  end

  defp create_interviews(%{user: user, other_user: other_user}) do
    %{
      interview: interview_fixture(%{user_id: user.id, name: "my interview"}),
      other_interview: interview_fixture(%{user_id: other_user.id, name: "other interview"}),
      invited_interview: interview_fixture(%{user_id: other_user.id, name: "invited interview"})
    }
  end

  defp create_interview_user(%{user: user, invited_interview: interview}) do
    {:ok, user_interview} =
      %{user_id: user.id, interview_id: interview.id}
      |> SmeInterviews.InterviewUsers.create_interview_user()

    %{user_interview: user_interview}
  end

  describe "Index" do
    setup [
      :register_confirm_and_log_in_user,
      :create_other_user,
      :create_interviews,
      :create_interview_user
    ]

    test "lists only permitted interviews", context do
      %{
        conn: conn,
        interview: interview,
        other_interview: other,
        invited_interview: invited
      } = context

      {:ok, _index_live, html} = live(conn, Routes.interview_index_path(conn, :index))

      assert html =~ "Listing Interviews"
      assert html =~ interview.name
      assert html =~ invited.name
      refute html =~ other.name
    end

    test "cannot edit disallowed interview", %{conn: conn, other_interview: interview} do
      assert {:error, {:live_redirect, _}} = live(conn, Routes.interview_index_path(conn, :edit, interview))
    end

    test "cannot edit unowned interview", %{conn: conn, invited_interview: interview} do
      assert {:error, {:live_redirect, _}} = live(conn, Routes.interview_index_path(conn, :edit, interview))
    end
  end

  describe "Show" do
    setup [
      :register_confirm_and_log_in_user,
      :create_other_user,
      :create_interviews,
      :create_interview_user
    ]


    test "cannot edit disallowed interview", %{conn: conn, other_interview: interview} do
      assert {:error, {:live_redirect, _}} = live(conn, Routes.interview_show_path(conn, :edit, interview))
    end

    test "cannot edit invited interview", %{conn: conn, invited_interview: interview} do
      assert {:error, {:live_redirect, _}} = live(conn, Routes.interview_show_path(conn, :edit, interview))
    end

    test "cannot view disallowed interview", %{conn: conn, other_interview: interview} do
      assert {:error, {:live_redirect, _}} = live(conn, Routes.interview_show_path(conn, :show, interview))
    end

    test "can view permitted interview", %{conn: conn, invited_interview: interview} do
      assert {:ok, _index_live, _html} = live(conn, Routes.interview_show_path(conn, :show, interview))
    end
  end
end
