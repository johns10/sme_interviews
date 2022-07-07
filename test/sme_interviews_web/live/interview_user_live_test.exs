defmodule SmeInterviewsWeb.InterviewUserLiveTest do
  use SmeInterviewsWeb.ConnCase

  import Phoenix.LiveViewTest
  import SmeInterviews.InterviewUsersFixtures

  setup :register_confirm_and_log_in_user

  @create_attrs %{"email" => "test@email.com", "interview_id" => "1"}
  @update_attrs %{"email" => "testes@email.com", "interview_id" => "2"}
  @invalid_attrs %{"email" => ""}

  defp create_interview_user(_) do
    interview_user = interview_user_fixture()
    %{interview_user: interview_user}
  end

  describe "Index" do
    setup [:create_interview_user]

    test "lists all interview_users", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.interview_user_index_path(conn, :index))

      assert html =~ "Listing Interview users"
    end

    test "saves new interview_user", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.interview_user_index_path(conn, :index))

      assert index_live |> element("a", "New Interview user") |> render_click() =~
               "New Interview user"

      assert_patch(index_live, Routes.interview_user_index_path(conn, :new))

      assert index_live
             |> form("#interview_user-form", interview_user_form: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#interview_user-form", interview_user_form: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.interview_user_index_path(conn, :index))

      assert html =~ "Interview user created successfully"
    end

    test "updates interview_user in listing", %{conn: conn, interview_user: interview_user} do
      {:ok, index_live, _html} = live(conn, Routes.interview_user_index_path(conn, :index))

      assert index_live |> element("#interview_user-#{interview_user.id} a", "Edit") |> render_click() =~
               "Edit Interview user"

      assert_patch(index_live, Routes.interview_user_index_path(conn, :edit, interview_user))

      assert index_live
             |> form("#interview_user-form", interview_user_form: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#interview_user-form", interview_user_form: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.interview_user_index_path(conn, :index))

      assert html =~ "Interview user updated successfully"
    end

    test "deletes interview_user in listing", %{conn: conn, interview_user: interview_user} do
      {:ok, index_live, _html} = live(conn, Routes.interview_user_index_path(conn, :index))

      assert index_live |> element("#interview_user-#{interview_user.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#interview_user-#{interview_user.id}")
    end
  end

  describe "Show" do
    setup [:create_interview_user]

    test "displays interview_user", %{conn: conn, interview_user: interview_user} do
      {:ok, _show_live, html} = live(conn, Routes.interview_user_show_path(conn, :show, interview_user))

      assert html =~ "Show Interview user"
    end

    test "updates interview_user within modal", %{conn: conn, interview_user: interview_user} do
      {:ok, show_live, _html} = live(conn, Routes.interview_user_show_path(conn, :show, interview_user))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Interview user"

      assert_patch(show_live, Routes.interview_user_show_path(conn, :edit, interview_user))

      assert show_live
             |> form("#interview_user-form", interview_user_form: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#interview_user-form", interview_user_form: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.interview_user_show_path(conn, :show, interview_user))

      assert html =~ "Interview user updated successfully"
    end
  end
end
