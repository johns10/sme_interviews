defmodule SmeInterviews.Repo.Migrations.CreateVoiceSamples do
  use Ecto.Migration

  def change do
    create table(:voice_samples) do
      add :text, :text
      add :user_id, references("users", on_delete: :nilify_all)
      add :aws_path, :string

      timestamps(type: :naive_datetime_usec)
    end

    create index(:voice_samples, [:user_id])
  end
end
