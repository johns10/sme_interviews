defmodule SmeInterviews.Repo.Migrations.CreateInterviews do
  use Ecto.Migration

  def change do
    create table(:interviews) do
      add :name, :string
      add :description, :string
      add :user_id, references("users", on_delete: :nilify_all)

      timestamps()
    end

    create index(:interviews, [:user_id])
  end
end
