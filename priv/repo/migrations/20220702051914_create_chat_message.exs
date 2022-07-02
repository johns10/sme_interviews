defmodule SMEInterviews.Repo.Migrations.CreateChatMessage do
  use Ecto.Migration

  def change do
    create table(:chat_message) do
      add :body, :text

      timestamps()
    end
  end
end
