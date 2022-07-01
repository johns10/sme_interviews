defmodule SMEInterviews.Interviews do
  @moduledoc """
  The Interviews context.
  """

  import Ecto.Query, warn: false
  alias SMEInterviews.Repo

  alias SMEInterviews.Interviews.Interview

  def list_interviews do
    Repo.all(Interview)
  end

  def get_interview!(id), do: Repo.get!(Interview, id)

  def preload_interview(interview, preloads), do: Repo.preload(interview, preloads)

  def create_interview(attrs \\ %{}) do
    %Interview{}
    |> Interview.changeset(attrs)
    |> Repo.insert()
  end

  def update_interview(%Interview{} = interview, attrs) do
    interview
    |> Interview.changeset(attrs)
    |> Repo.update()
  end

  def delete_interview(%Interview{} = interview) do
    Repo.delete(interview)
  end

  def change_interview(%Interview{} = interview, attrs \\ %{}) do
    Interview.changeset(interview, attrs)
  end
end
