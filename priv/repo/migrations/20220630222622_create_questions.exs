defmodule SMEInterviews.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :body, :text
      add :status, :string

      timestamps()
    end
  end
end
