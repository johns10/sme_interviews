defmodule SmeInterviewsWeb.QuestionTemplateLiveTest do
  use SmeInterviewsWeb.ConnCase

  import Phoenix.LiveViewTest
  import SmeInterviews.QuestionTemplatesFixtures

  @create_attrs %{body: "some body"}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  defp create_question_template(_) do
    question_template = question_template_fixture()
    %{question_template: question_template}
  end

  describe "Index" do
    setup [
      :register_confirm_and_log_in_user,
      :create_question_template
    ]

    test "lists all question_template", %{conn: conn, question_template: question_template} do
      {:ok, _index_live, html} = live(conn, Routes.question_template_index_path(conn, :index))

      assert html =~ "Listing Question template"
      assert html =~ question_template.body
    end

    test "saves new question_template", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.question_template_index_path(conn, :index))

      assert index_live |> element("a", "New Question template") |> render_click() =~
               "New Question template"

      assert_patch(index_live, Routes.question_template_index_path(conn, :new))

      assert index_live
             |> form("#question_template-form", question_template: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#question_template-form", question_template: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.question_template_index_path(conn, :index))

      assert html =~ "Question template created successfully"
      assert html =~ "some body"
    end

    test "updates question_template in listing", %{
      conn: conn,
      question_template: question_template
    } do
      {:ok, index_live, _html} = live(conn, Routes.question_template_index_path(conn, :index))

      assert index_live
             |> element("#question_template-#{question_template.id} a", "Edit")
             |> render_click() =~
               "Edit Question template"

      assert_patch(
        index_live,
        Routes.question_template_index_path(conn, :edit, question_template)
      )

      assert index_live
             |> form("#question_template-form", question_template: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#question_template-form", question_template: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.question_template_index_path(conn, :index))

      assert html =~ "Question template updated successfully"
      assert html =~ "some updated body"
    end

    test "deletes question_template in listing", %{
      conn: conn,
      question_template: question_template
    } do
      {:ok, index_live, _html} = live(conn, Routes.question_template_index_path(conn, :index))

      assert index_live
             |> element("#question_template-#{question_template.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#question_template-#{question_template.id}")
    end
  end

  describe "Show" do
    setup [
      :register_confirm_and_log_in_user,
      :create_question_template
    ]

    test "displays question_template", %{conn: conn, question_template: question_template} do
      {:ok, _show_live, html} =
        live(conn, Routes.question_template_show_path(conn, :show, question_template))

      assert html =~ "Show Question template"
      assert html =~ question_template.body
    end

    test "updates question_template within modal", %{
      conn: conn,
      question_template: question_template
    } do
      {:ok, show_live, _html} =
        live(conn, Routes.question_template_show_path(conn, :show, question_template))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Question template"

      assert_patch(show_live, Routes.question_template_show_path(conn, :edit, question_template))

      assert show_live
             |> form("#question_template-form", question_template: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#question_template-form", question_template: @update_attrs)
        |> render_submit()
        |> follow_redirect(
          conn,
          Routes.question_template_show_path(conn, :show, question_template)
        )

      assert html =~ "Question template updated successfully"
      assert html =~ "some updated body"
    end
  end
end
