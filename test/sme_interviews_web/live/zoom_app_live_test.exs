defmodule SmeInterviewsWeb.ZoomAppLiveTest do
  use SmeInterviewsWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "Unauthenticated Index" do
    test "redirects", %{conn: conn} do
      {:error, {:live_redirect, %{flash: %{}, to: "/users/log_in?app=zoom"}}} =
        live(conn, Routes.zoom_app_index_path(conn, :index))
    end
  end

  describe "Authenticated Index" do
    setup :register_confirm_and_log_in_user

    test "renders", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.zoom_app_index_path(conn, :index))
      assert html =~ "account not authorized"
    end
  end
end
