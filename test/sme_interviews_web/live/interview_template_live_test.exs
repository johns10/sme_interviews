defmodule SmeInterviewsWeb.InterviewTemplateLiveTest do
  use SmeInterviewsWeb.ConnCase

  import Phoenix.LiveViewTest
  import SmeInterviews.InterviewTemplatesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_interview_template(_) do
    interview_template = interview_template_fixture()
    %{interview_template: interview_template}
  end

  describe "Index" do
    setup [
      :register_confirm_and_log_in_user,
      :create_interview_template
    ]

    test "lists all interview_templates", %{conn: conn, interview_template: interview_template} do
      {:ok, _index_live, html} = live(conn, Routes.interview_template_index_path(conn, :index))

      assert html =~ "Listing Interview templates"
      assert html =~ interview_template.name
    end

    test "saves new interview_template", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.interview_template_index_path(conn, :index))

      assert index_live |> element("a", "New Template") |> render_click() =~
               "New Interview template"

      assert_patch(index_live, Routes.interview_template_index_path(conn, :new))

      assert index_live
             |> form("#interview_template-form", interview_template: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#interview_template-form", interview_template: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.interview_template_index_path(conn, :index))

      assert html =~ "Interview template created successfully"
    end

    test "updates interview_template in listing", %{
      conn: conn,
      interview_template: interview_template
    } do
      {:ok, index_live, _html} = live(conn, Routes.interview_template_index_path(conn, :index))

      assert index_live
             |> element("#interview_template-#{interview_template.id} a", "Edit")
             |> render_click() =~
               "Edit Interview template"

      assert_patch(
        index_live,
        Routes.interview_template_index_path(conn, :edit, interview_template)
      )

      assert index_live
             |> form("#interview_template-form", interview_template: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#interview_template-form", interview_template: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.interview_template_index_path(conn, :index))

      assert html =~ "Interview template updated successfully"
    end

    test "deletes interview_template in listing", %{
      conn: conn,
      interview_template: interview_template
    } do
      {:ok, index_live, _html} = live(conn, Routes.interview_template_index_path(conn, :index))

      assert index_live
             |> element("#interview_template-#{interview_template.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#interview_template-#{interview_template.id}")
    end
  end

  describe "Show" do
    setup [
      :register_confirm_and_log_in_user,
      :create_interview_template
    ]

    test "displays interview_template", %{conn: conn, interview_template: interview_template} do
      {:ok, _show_live, html} =
        live(conn, Routes.interview_template_show_path(conn, :show, interview_template))

      assert html =~ "Show Interview template"
      assert html =~ interview_template.name
    end

    test "updates interview_template within modal", %{
      conn: conn,
      interview_template: interview_template
    } do
      {:ok, show_live, _html} =
        live(conn, Routes.interview_template_show_path(conn, :show, interview_template))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Interview template"

      assert_patch(
        show_live,
        Routes.interview_template_show_path(conn, :edit, interview_template)
      )

      assert show_live
             |> form("#interview_template-form", interview_template: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#interview_template-form", interview_template: @update_attrs)
        |> render_submit()
        |> follow_redirect(
          conn,
          Routes.interview_template_show_path(conn, :show, interview_template)
        )

      assert html =~ "Interview template updated successfully"
    end
  end
end
