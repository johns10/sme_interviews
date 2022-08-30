defmodule SmeInterviews.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :from, :naive_datetime
      add :to, :naive_datetime
      add :text, :text
      add :interview_id, references(:interviews, on_delete: :nothing)

      timestamps(type: :naive_datetime_usec)
    end

    create index(:entries, [:interview_id])
  end
end
