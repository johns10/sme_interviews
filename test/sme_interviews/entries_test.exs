defmodule SmeInterviews.EntriesTest do
  use SmeInterviews.DataCase

  alias SmeInterviews.Entries

  describe "entries" do
    alias SmeInterviews.Entries.Entry

    import SmeInterviews.EntriesFixtures

    @invalid_attrs %{from: "face", text: nil, to: nil}

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Entries.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Entries.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      valid_attrs = %{
        from: ~N[2022-08-25 03:42:00],
        text: "some text",
        to: ~N[2022-08-25 03:42:00],
        id: Ecto.UUID.generate()
      }

      assert {:ok, %Entry{} = entry} = Entries.create_entry(valid_attrs)
      assert entry.from == ~N[2022-08-25 03:42:00]
      assert entry.text == "some text"
      assert entry.to == ~N[2022-08-25 03:42:00]
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entries.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()

      update_attrs = %{
        from: ~N[2022-08-26 03:42:00],
        text: "some updated text",
        to: ~N[2022-08-26 03:42:00]
      }

      assert {:ok, %Entry{} = entry} = Entries.update_entry(entry, update_attrs)
      assert entry.from == ~N[2022-08-26 03:42:00]
      assert entry.text == "some updated text"
      assert entry.to == ~N[2022-08-26 03:42:00]
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Entries.update_entry(entry, @invalid_attrs)
      assert entry == Entries.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Entries.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Entries.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Entries.change_entry(entry)
    end
  end
end
