defmodule SmeInterviews.Repo.Migrations.CreateInterviews do
  use Ecto.Migration

  def change do
    create table(:interviews) do
      add :name, :string
      add :description, :string

      timestamps()
    end
  end
end
