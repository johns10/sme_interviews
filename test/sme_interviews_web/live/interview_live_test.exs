defmodule SMEInterviewsWeb.InterviewLiveTest do
  use SMEInterviewsWeb.ConnCase

  import Phoenix.LiveViewTest
  import SMEInterviews.InterviewsFixtures

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  defp create_interview(_) do
    interview = interview_fixture()
    %{interview: interview}
  end

  describe "Index" do
    setup [:create_interview]

    test "lists all interviews", %{conn: conn, interview: interview} do
      {:ok, _index_live, html} = live(conn, Routes.interview_index_path(conn, :index))

      assert html =~ "Listing Interviews"
      assert html =~ interview.description
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
      assert html =~ "some description"
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
      assert html =~ "some updated description"
    end

    test "deletes interview in listing", %{conn: conn, interview: interview} do
      {:ok, index_live, _html} = live(conn, Routes.interview_index_path(conn, :index))

      assert index_live |> element("#interview-#{interview.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#interview-#{interview.id}")
    end
  end

  describe "Show" do
    setup [:create_interview]

    test "displays interview", %{conn: conn, interview: interview} do
      {:ok, _show_live, html} = live(conn, Routes.interview_show_path(conn, :show, interview))

      assert html =~ "Show Interview"
      assert html =~ interview.description
    end

    test "updates interview within modal", %{conn: conn, interview: interview} do
      {:ok, show_live, _html} = live(conn, Routes.interview_show_path(conn, :show, interview))

      assert show_live |> element("a", "Edit") |> render_click() =~
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
      assert html =~ "some updated description"
    end
  end
end
