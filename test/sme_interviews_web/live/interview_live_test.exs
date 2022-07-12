defmodule SmeInterviewsWeb.InterviewLiveTest do
  use SmeInterviewsWeb.ConnCase
  import Phoenix.LiveViewTest
  import SmeInterviews.InterviewsFixtures

  setup :register_confirm_and_log_in_user

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_interview(%{user: %{id: id}}) do
    interview = interview_fixture(%{user_id: id})
    %{interview: interview}
  end

  describe "Index" do
    setup [
      :register_confirm_and_log_in_user,
      :create_interview
    ]

    test "lists all interviews", %{conn: conn, interview: interview} do
      {:ok, _index_live, html} = live(conn, Routes.interview_index_path(conn, :index))

      assert html =~ "Listing Interviews"
      assert html =~ interview.name
    end

    test "saves new interview", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.interview_index_path(conn, :index))

      assert index_live |> element("a", "New Interview") |> render_click() =~
               "New Interview"

      assert_patch(index_live, Routes.interview_index_path(conn, :new))

      assert index_live
             |> form("#interview-form", interview: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#interview-form", interview: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.interview_index_path(conn, :index))

      assert html =~ "Interview created successfully"
      assert html =~ "some name"
    end

    test "updates interview in listing", %{conn: conn, interview: interview} do
      {:ok, index_live, _html} = live(conn, Routes.interview_index_path(conn, :index))

      assert index_live |> element("#interview-#{interview.id} a", "Edit") |> render_click() =~
               "Edit Interview"

      assert_patch(index_live, Routes.interview_index_path(conn, :edit, interview))

      assert index_live
             |> form("#interview-form", interview: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#interview-form", interview: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.interview_index_path(conn, :index))

      assert html =~ "Interview updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes interview in listing", %{conn: conn, interview: interview} do
      {:ok, index_live, _html} = live(conn, Routes.interview_index_path(conn, :index))

      assert index_live |> element("#interview-#{interview.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#interview-#{interview.id}")
    end
  end

  describe "Show" do
    setup [
      :register_confirm_and_log_in_user,
      :create_interview
    ]

    test "displays interview", %{conn: conn, interview: interview} do
      {:ok, _show_live, html} = live(conn, Routes.interview_show_path(conn, :show, interview))

      assert html =~ "Show Interview"
      assert html =~ interview.name
    end

    test "updates interview within modal", %{conn: conn, interview: interview} do
      {:ok, show_live, _html} = live(conn, Routes.interview_show_path(conn, :show, interview))

      assert show_live |> element("#edit-interview") |> render_click() =~
               "Edit Interview"

      assert_patch(show_live, Routes.interview_show_path(conn, :edit, interview))

      assert show_live
             |> form("#interview-form", interview: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#interview-form", interview: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.interview_show_path(conn, :show, interview))

      assert html =~ "Interview updated successfully"
      assert html =~ "some updated name"
    end
  end
end
