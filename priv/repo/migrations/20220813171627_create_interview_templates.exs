defmodule SmeInterviews.Repo.Migrations.CreateInterviewTemplates do
  use Ecto.Migration

  def change do
    create table(:interview_templates) do
      add :description, :string
      add :name, :string
      add :user_id, references("users", on_delete: :nilify_all)

      timestamps()
    end

    create index(:interview_templates, [:user_id])
  end
end
