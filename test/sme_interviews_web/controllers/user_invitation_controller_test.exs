defmodule SmeInterviewsWeb.UserInvitationControllerTest do
  use SmeInterviewsWeb.ConnCase, async: true

  alias SmeInterviews.Accounts
  alias SmeInterviews.Repo
  import SmeInterviews.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "GET /users/invitation/:token" do
    test "renders the invitation page", %{conn: conn} do
      conn = get(conn, Routes.user_invitation_path(conn, :edit, "some-token"))
      response = html_response(conn, 200)
      assert response =~ "Accept invitation"

      form_action = Routes.user_invitation_path(conn, :update, "some-token")
      assert response =~ "action=\"#{form_action}\""
    end
  end

  describe "POST /users/invitation/:token" do
    test "accepts the invitation once", %{conn: conn, user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_invitation_instructions(user, url)
        end)

      conn =
        post(conn, Routes.user_invitation_path(conn, :update, token), %{
          "user" => %{"password" => valid_user_password()}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "Invitation accepted"
      assert Accounts.get_user!(user.id).confirmed_at
      refute get_session(conn, :user_token)
      assert Repo.all(Accounts.UserToken) == []

      # When not logged in
      conn = post(conn, Routes.user_invitation_path(conn, :update, token), %{
        "user" => %{"password" => valid_user_password()}
      })
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "User invitation link is invalid or it has expired"

      # When logged in
      conn =
        build_conn()
        |> log_in_user(user)
        |> post(Routes.user_confirmation_path(conn, :update, token))

      assert redirected_to(conn) == "/"
      refute get_flash(conn, :error)
    end

    test "does not confirm email with invalid token", %{conn: conn, user: user} do
      conn = post(conn, Routes.user_invitation_path(conn, :update, "oops"), %{"user" => %{"password" => "anything"}})
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "User invitation link is invalid or it has expired"
      refute Accounts.get_user!(user.id).confirmed_at
    end
  end
end
