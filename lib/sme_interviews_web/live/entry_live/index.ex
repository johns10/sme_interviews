defmodule SmeInterviewsWeb.EntryLive.Index do
  use SmeInterviewsWeb, :live_view
  on_mount SmeInterviewsWeb.UserLiveAuth

  alias SmeInterviews.Entries
  alias SmeInterviews.Entries.Entry

  @bucket Application.get_env(:sme_interviews, :s3_bucket_name, "smeinterviews")

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:entries, list_entries())
     |> assign(:current_entry, %Entry{id: "test"})
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

  def handle_event("utterance-started", %{"id" => id}, socket) do
    {:ok, entry} = Entries.create_entry(%{from: DateTime.utc_now(), id: id})
    {:noreply, socket |> assign(:current_entry, entry) |> assign(:speaking?, true)}
  end

  def handle_event("utterance-ended", %{"id" => id}, socket) do
    {:ok, entry} =
      socket.assigns.current_entry
      |> Entries.update_entry(%{to: DateTime.utc_now(), id: id})

    {:reply, %{url: presigned_url(id, :put)},
     socket
     |> assign(:entries, socket.assigns.entries ++ [entry])
     |> assign(:current_entry, %Entry{id: "test"})
     |> assign(:speaking?, false)}
  end

  def handle_event("utterance-uploaded", %{"id" => id}, socket) do
    entries =
      socket.assigns.entries
      |> Enum.map(fn
        %{id: ^id} = entry -> Map.put(entry, :get_url, presigned_url(id, :get))
        entry -> entry
      end)

    {:noreply, socket |> assign(:entries, entries)}
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

  defp presigned_url(id, method) do
    {:ok, url} =
      ExAws.Config.new(:s3)
      |> provider().presigned_url(method, @bucket, "utterances/#{id}.wav")

    url
  end

  defp provider(), do: Application.get_env(:sme_interviews, :S3Provider, ExAws.S3)
end
