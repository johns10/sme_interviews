defmodule SmeInterviews.InterviewTemplates do
  @moduledoc """
  The InterviewTemplates context.
  """

  import Ecto.Query, warn: false
  alias SmeInterviews.Repo

  alias SmeInterviews.InterviewTemplates.InterviewTemplate

  def list_interview_templates do
    Repo.all(InterviewTemplate)
  end

  def get_interview_template!(id), do: Repo.get!(InterviewTemplate, id)

  def get_complete_interview_template!(id) do
    InterviewTemplate
    |> where([i], i.id == ^id)
    |> preload([:question_templates])
    |> Repo.one!()
  end

  def create_interview_template(attrs \\ %{}) do
    %InterviewTemplate{}
    |> InterviewTemplate.changeset(attrs)
    |> Repo.insert()
  end

  def update_interview_template(%InterviewTemplate{} = interview_template, attrs) do
    interview_template
    |> InterviewTemplate.changeset(attrs)
    |> Repo.update()
  end

  def delete_interview_template(%InterviewTemplate{} = interview_template) do
    Repo.delete(interview_template)
  end

  def change_interview_template(%InterviewTemplate{} = interview_template, attrs \\ %{}) do
    InterviewTemplate.changeset(interview_template, attrs)
  end
end
