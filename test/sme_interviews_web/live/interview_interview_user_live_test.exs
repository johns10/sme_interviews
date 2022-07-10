defmodule SmeInterviewsWeb.InterviewInterviewUsersLiveTest do
  use SmeInterviewsWeb.ConnCase
  import Phoenix.LiveViewTest
  import SmeInterviews.InterviewsFixtures
  import SmeInterviews.AccountsFixtures

  setup :register_confirm_and_log_in_user

  defp create_other_user(_) do
    user = user_fixture()
    %{other_user: user}
  end

  defp create_interview(%{user: user}) do
    interview = interview_fixture(%{user_id: user.id})
    %{interview: interview}
  end

  describe "Show" do
    setup [
      :register_confirm_and_log_in_user,
      :create_other_user,
      :create_interview
    ]

    test "adds existing interview user", %{conn: conn, interview: interview, other_user: other_user} do
      SmeInterviewsWeb.Endpoint.subscribe("interview:#{interview.id}")
      {:ok, show_live, _html} = live(conn, Routes.interview_show_path(conn, :show, interview))

      assert show_live |> element("#edit-interview-users") |> render_click() =~
               "Users"

      assert_patch(show_live, Routes.interview_show_path(conn, :edit_users, interview))

      assert show_live
             |> form("#interview_user-form", interview_user_form: %{"email" => ""})
             |> render_change() =~ "can&#39;t be blank"

      attrs = %{"email" => other_user.email, "interview_id" => interview.id}

      show_live
      |> form("#interview_user-form", interview_user_form: attrs)
      |> render_submit()

      assert_receive(%{event: "create", payload: %SmeInterviews.InterviewUsers.InterviewUser{}})

      html = render(show_live)
      assert html =~ other_user.email
    end

    test "adds new interview user", %{conn: conn, interview: interview} do
      SmeInterviewsWeb.Endpoint.subscribe("interview:#{interview.id}")
      {:ok, show_live, _html} = live(conn, Routes.interview_show_path(conn, :edit_users, interview))

      attrs = %{"email" => "new@email.com", "interview_id" => interview.id}

      show_live
      |> form("#interview_user-form", interview_user_form: attrs)
      |> render_submit()

      assert_receive(%{event: "create", payload: %SmeInterviews.InterviewUsers.InterviewUser{}})

      html = render(show_live)
      assert html =~ "new@email.com"
    end
  end
end
