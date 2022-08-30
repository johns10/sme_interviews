defmodule SmeInterviews.EntriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SmeInterviews.Entries` context.
  """

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(%{
        id: Ecto.UUID.generate(),
        from: ~N[2022-08-25 03:42:00],
        text: "some text",
        to: ~N[2022-08-25 03:42:00]
      })
      |> SmeInterviews.Entries.create_entry()

    entry
  end
end
