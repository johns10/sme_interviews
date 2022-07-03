defmodule SmeInterviewsWeb.PageController do
  use SmeInterviewsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
