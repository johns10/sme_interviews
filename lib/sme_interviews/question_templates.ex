defmodule SmeInterviews.QuestionTemplates do
  @moduledoc """
  The QuestionTemplates context.
  """

  import Ecto.Query, warn: false
  alias SmeInterviews.Repo
  alias SmeInterviews.Subscription
  alias SmeInterviews.QuestionTemplates.QuestionTemplate

  def list_question_template do
    Repo.all(QuestionTemplate)
  end

  def get_question_template!(id), do: Repo.get!(QuestionTemplate, id)

  def create_question_template(attrs \\ %{}) do
    %QuestionTemplate{}
    |> QuestionTemplate.changeset(attrs)
    |> Repo.insert()
    |> Subscription.broadcast_result()
  end

  def update_question_template(%QuestionTemplate{} = question_template, attrs) do
    question_template
    |> QuestionTemplate.changeset(attrs)
    |> Repo.update()
    |> Subscription.broadcast_result()
  end

  def delete_question_template(%QuestionTemplate{} = question_template) do
    Repo.delete(question_template)
    |> Subscription.broadcast_result()
  end

  def change_question_template(%QuestionTemplate{} = question_template, attrs \\ %{}) do
    QuestionTemplate.changeset(question_template, attrs)
  end
end
