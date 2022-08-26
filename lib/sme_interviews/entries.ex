defmodule SmeInterviews.Entries do
  @moduledoc """
  The Entries context.
  """

  import Ecto.Query, warn: false
  alias SmeInterviews.Repo

  alias SmeInterviews.Entries.Entry

  def list_entries do
    Repo.all(Entry)
  end

  def get_entry!(id), do: Repo.get!(Entry, id)

  def create_entry(attrs \\ %{}) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> Repo.insert()
  end

  def update_entry(%Entry{} = entry, attrs) do
    entry
    |> Entry.changeset(attrs)
    |> Repo.update()
  end

  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
  end

  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    Entry.changeset(entry, attrs)
  end
end
