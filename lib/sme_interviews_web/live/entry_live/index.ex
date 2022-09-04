defmodule SmeInterviewsWeb.EntryLive.Index do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.Entries
  alias SmeInterviews.Entries.Entry

  @bucket Application.get_env(:sme_interviews, :s3_bucket_name, "smeinterviews")

  @impl true
  def mount(_params, _session, socket) do
    config = ExAws.Config.new(:s3)
    {:ok, model_url} = provider().presigned_url(config, :get, @bucket, "model.tflite")
    {:ok, scorer_url} = provider().presigned_url(config, :get, @bucket, "model.scorer")

    {:ok,
     socket
     |> assign(:model_url, model_url)
     |> assign(:scorer_url, scorer_url)
     |> assign(:entries, list_entries())
     |> assign(:speaking?, false)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Entry")
    |> assign(:entry, Entries.get_entry!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Entry")
    |> assign(:entry, %Entry{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Entries")
    |> assign(:entry, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    entry = Entries.get_entry!(id)
    {:ok, _} = Entries.delete_entry(entry)
    provider().delete_object(@bucket, "utterances/#{id}.wav")

    {:noreply, assign(socket, :entries, list_entries())}
  end

  def handle_event("utterance-started", %{"id" => id, "status" => status}, socket) do
    {:ok, entry} = Entries.create_entry(%{from: DateTime.utc_now(), id: id, status: status})
    entries = socket.assigns.entries ++ [entry]
    {:noreply, socket |> assign(:entries, entries) |> assign(:speaking?, true)}
  end

  def handle_event("utterance-updated", attrs, socket) do
    entries = update_entries(socket.assigns.entries, attrs)
    {:noreply, socket |> assign(:entries, entries)}
  end

  def handle_event("utterance-ended", %{"id" => id}, socket) do
    entries = update_entries(socket.assigns.entries, %{"id" => id, "to" => DateTime.utc_now()})

    {:reply, %{url: presigned_url(id, :put)},
     socket
     |> assign(:entries, entries)
     |> assign(:speaking?, false)}
  end

  def handle_event("utterance-uploaded", %{"id" => id}, socket) do
    attrs = %{"id" => id, "get_url" => presigned_url(id, :get)}
    entries = update_entries(socket.assigns.entries, attrs)
    {:noreply, socket |> assign(:entries, entries) |> push_event("utterance-available", %{})}
  end

  def handle_event("transcription-finished", attrs, socket) do
    entries = update_entries(socket.assigns.entries, attrs)
    {:noreply, socket |> assign(:entries, entries)}
  end

  def handle_event("transcriber-idle", _, socket) do
    entry =
      case Entries.list_incomplete_entries() do
        [] ->
          nil

        entries ->
          entry = entries |> Enum.at(0)
          Map.put(entry, :get_url, presigned_url(entry.id, :get))
      end

    {:reply, %{entry: entry}, socket}
  end

  defp list_entries do
    Entries.list_entries()
    |> Enum.map(fn entry ->
      {:ok, url} =
        ExAws.Config.new(:s3)
        |> provider().presigned_url(:get, @bucket, "utterances/#{entry.id}.wav")

      Map.put(entry, :get_url, url)
    end)
  end

  defp update_entries(entries, %{"id" => id} = attrs) do
    {:ok, entry} =
      Entries.get_entry!(id)
      |> Entries.update_entry(attrs)

    Enum.map(entries, fn
      %Entry{id: ^id} -> entry
      old_entry -> old_entry
    end)
  end

  defp presigned_url(id, method) do
    {:ok, url} =
      ExAws.Config.new(:s3)
      |> provider().presigned_url(method, @bucket, "utterances/#{id}.wav")

    url
  end

  defp provider(), do: Application.get_env(:sme_interviews, :S3Provider, ExAws.S3)
end
