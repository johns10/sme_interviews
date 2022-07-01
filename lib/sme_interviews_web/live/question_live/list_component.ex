defmodule SMEInterviewsWeb.QuestionLive.ListComponent do
  use SMEInterviewsWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

end
