defmodule SmeInterviewsWeb.ZoomAuthController do
  use SmeInterviewsWeb, :controller

  def index(conn, %{"code" => code}) do
    conn
    |> assign(:code, code)
    |> render("index.html")
  end
end
