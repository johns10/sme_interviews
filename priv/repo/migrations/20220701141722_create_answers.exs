defmodule SMEInterviews.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :body, :text
      add :order, :integer
      add :selected, :boolean, default: false, null: false
      add :question_id, references("questions", on_delete: :delete_all)

      timestamps()
    end

    create index(:answers, [:question_id])
  end
end
