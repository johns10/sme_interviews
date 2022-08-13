defmodule SmeInterviewsWeb.UserRegistrationController do
  use SmeInterviewsWeb, :controller

  alias SmeInterviews.Accounts
  alias SmeInterviews.Accounts.User
  alias SmeInterviewsWeb.UserAuth

  def new(conn, %{"zoom_auth_code" => zoom_auth_code} = params) do
    conn
    |> assign(:zoom_auth_code, zoom_auth_code)
    |> do_new(Map.delete(params, "zoom_auth_code"))
  end

  def new(conn, params), do: conn |> assign_defaults() |> do_new(params)

  def create(conn, %{"zoom_auth_code" => zoom_auth_code} = params) do
    IO.puts(zoom_auth_code)
    conn
    |> do_create(Map.delete(params, "zoom_auth_code"))
  end
  def create(conn, params), do: do_create(conn, params)

  defp do_new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  defp do_create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign_defaults()
        |> render("new.html", changeset: changeset)
    end
  end

  defp assign_defaults(conn), do: conn |> assign(:zoom_auth_code, "")
end
