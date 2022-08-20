defmodule SmeInterviewsWeb.VoiceSampleLiveTest do
  use SmeInterviewsWeb.ConnCase

  import Phoenix.LiveViewTest
  import SmeInterviews.VoiceSamplesFixtures

  @create_attrs %{text: "some text"}
  @update_attrs %{text: "some updated text"}
  @invalid_attrs %{text: nil}

  defp create_voice_sample(_) do
    voice_sample = voice_sample_fixture()
    %{voice_sample: voice_sample}
  end

  describe "Index" do
    setup [:register_confirm_and_log_in_user, :create_voice_sample]

    test "lists all voice_samples", %{conn: conn, voice_sample: voice_sample} do
      {:ok, _index_live, html} = live(conn, Routes.voice_sample_index_path(conn, :index))

      assert html =~ "Listing Voice Samples"
      assert html =~ voice_sample.text
    end

    test "saves new voice_sample", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.voice_sample_index_path(conn, :index))

      assert index_live |> element("a", "New Voice Sample") |> render_click() =~
               "New Voice Sample"

      assert_patch(index_live, Routes.voice_sample_index_path(conn, :new))

      assert index_live
             |> form("#voice_sample-form", voice_sample: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#voice_sample-form", voice_sample: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.voice_sample_index_path(conn, :index))

      assert html =~ "Voice Sample created successfully"
      assert html =~ "some text"
    end

    test "updates voice_sample in listing", %{
      conn: conn,
      voice_sample: voice_sample
    } do
      {:ok, index_live, _html} = live(conn, Routes.voice_sample_index_path(conn, :index))

      assert index_live
             |> element("#voice_sample-#{voice_sample.id} a", "Edit")
             |> render_click() =~
               "Edit Voice Sample"

      assert_patch(
        index_live,
        Routes.voice_sample_index_path(conn, :edit, voice_sample)
      )

      assert index_live
             |> form("#voice_sample-form", voice_sample: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#voice_sample-form", voice_sample: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.voice_sample_index_path(conn, :index))

      assert html =~ "Voice Sample updated successfully"
      assert html =~ "some updated text"
    end

    test "deletes voice_sample in listing", %{
      conn: conn,
      voice_sample: voice_sample
    } do
      {:ok, index_live, _html} = live(conn, Routes.voice_sample_index_path(conn, :index))

      assert index_live
             |> element("#voice_sample-#{voice_sample.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#voice_sample-#{voice_sample.id}")
    end
  end

  describe "Show" do
    setup [:register_confirm_and_log_in_user, :create_voice_sample]

    test "displays voice_sample", %{conn: conn, voice_sample: voice_sample} do
      {:ok, _show_live, html} =
        live(conn, Routes.voice_sample_show_path(conn, :show, voice_sample))

      assert html =~ "Show Voice Sample"
      assert html =~ voice_sample.text
    end

    test "updates voice_sample within modal", %{
      conn: conn,
      voice_sample: voice_sample
    } do
      {:ok, show_live, _html} =
        live(conn, Routes.voice_sample_show_path(conn, :show, voice_sample))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Voice Sample"

      assert_patch(
        show_live,
        Routes.voice_sample_show_path(conn, :edit, voice_sample)
      )

      assert show_live
             |> form("#voice_sample-form", voice_sample: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#voice_sample-form", voice_sample: @update_attrs)
        |> render_submit()
        |> follow_redirect(
          conn,
          Routes.voice_sample_show_path(conn, :show, voice_sample)
        )

      assert html =~ "Voice Sample updated successfully"
      assert html =~ "some updated text"
    end
  end
end
