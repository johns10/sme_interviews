defmodule SmeInterviews.Repo.Migrations.CreateQuestionTemplate do
  use Ecto.Migration

  def change do
    create table(:question_templates) do
      add :body, :string
      add :interview_template_id, references("interview_templates", on_delete: :delete_all)

      timestamps()
    end

    create index(:question_templates, [:interview_template_id])
  end
end
