defmodule SmeInterviews.Repo.Migrations.CreateInterviewUsers do
  use Ecto.Migration

  def change do
    create table(:interview_users) do
      add :user_id, references(:users, on_delete: :nothing)
      add :interview_id, references(:interviews, on_delete: :nothing)

      timestamps()
    end

    create index(:interview_users, [:user_id])
    create index(:interview_users, [:interview_id])
  end
end
