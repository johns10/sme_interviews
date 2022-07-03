defmodule SmeInterviews.Repo.Migrations.CreateChatMessage do
  use Ecto.Migration

  def change do
    create table(:chat_message) do
      add :body, :text
      add :question_id, references("questions", on_delete: :delete_all)

      timestamps()
    end

    create index(:chat_message, [:question_id])
  end
end
