defmodule SmeInterviewsWeb.VoiceSampleLive.Index do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.VoiceSamples
  alias SmeInterviews.VoiceSamples.VoiceSample
  alias SmeInterviews.TextSnippets

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:microphone_permission, :unknown)
      |> assign(:voice_samples, list_voice_samples())
      |> assign(:return_to, Routes.voice_sample_index_path(socket, :index))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Voice Sample")
    |> assign(:voice_sample, VoiceSamples.get_voice_sample!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Voice Sample")
    |> assign(:voice_sample, %VoiceSample{text: TextSnippets.get_random_text_snippet()})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Voice Samples")
    |> assign(:voice_sample, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    voice_sample = VoiceSamples.get_voice_sample!(id)
    {:ok, _} = VoiceSamples.delete_voice_sample(voice_sample)

    {:noreply, assign(socket, :voice_samples, list_voice_samples())}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end

  def handle_event("mic-permission-updated", %{"state" => state}, socket) do
    {:noreply, assign(socket, :microphone_permission, String.to_atom(state))}
  end

  defp list_voice_samples do
    VoiceSamples.list_voice_samples()
  end
end
