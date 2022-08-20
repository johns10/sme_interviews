defmodule SmeInterviewsWeb.VoiceSampleLive.Show do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.VoiceSamples

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:return_to, Routes.voice_sample_show_path(socket, :show, id))
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:voice_sample, VoiceSamples.get_voice_sample!(id))}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end

  defp page_title(:show), do: "Show Voice Sample"
  defp page_title(:edit), do: "Edit Voice Sample"
end
