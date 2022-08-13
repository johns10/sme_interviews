defmodule SmeInterviewsWeb.QuestionTemplateLive.ListComponent do
  use SmeInterviewsWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end
end
