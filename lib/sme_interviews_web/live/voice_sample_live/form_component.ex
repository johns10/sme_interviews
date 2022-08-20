defmodule SmeInterviewsWeb.VoiceSampleLive.FormComponent do
  use SmeInterviewsWeb, :live_component

  alias SmeInterviews.VoiceSamples

  @impl true
  def update(%{voice_sample: voice_sample} = assigns, socket) do
    changeset = VoiceSamples.change_voice_sample(voice_sample)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"voice_sample" => voice_sample_params}, socket) do
    changeset =
      socket.assigns.voice_sample
      |> VoiceSamples.change_voice_sample(voice_sample_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"voice_sample" => voice_sample_params}, socket) do
    save_voice_sample(socket, socket.assigns.action, voice_sample_params)
  end

  defp save_voice_sample(socket, :edit, voice_sample_params) do
    case VoiceSamples.update_voice_sample(
           socket.assigns.voice_sample,
           voice_sample_params
         ) do
      {:ok, _voice_sample} ->
        {:noreply,
         socket
         |> put_flash(:info, "Voice Sample updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_voice_sample(socket, :new, voice_sample_params) do
    case VoiceSamples.create_voice_sample(voice_sample_params) do
      {:ok, _voice_sample} ->
        {:noreply,
         socket
         |> put_flash(:info, "Voice Sample created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
