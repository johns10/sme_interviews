defmodule SMEInterviews.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :body, :text
      add :status, :string
      add :interview_id, references("interviews")

      timestamps()
    end
  end
end
