defmodule SmeInterviews.Questions do
  @moduledoc """
  The Questions context.
  """

  import Ecto.Query, warn: false
  alias SmeInterviews.Repo
  alias SmeInterviews.Subscription
  alias SmeInterviews.Questions.Question
  alias SmeInterviews.Interviews.Interview
  alias SmeInterviews.QuestionTemplates.QuestionTemplate

  def list_questions do
    Repo.all(Question)
  end

  def get_question!(id), do: Repo.get!(Question, id)

  def take_template_fields(%QuestionTemplate{body: body}, %{id: interview_id}) do
    %{body: body, interview_id: interview_id, status: :open}
  end

  def create_questions(templates, interview) when is_list(templates) do
    templates
    |> Enum.map(fn question_template ->
      case create_question(question_template, interview) do
        {:ok, question} -> question
        _ -> %{body: "This question failed to be created from the template. Create Manually."}
      end
    end)
  end

  def create_question(%QuestionTemplate{} = template, %Interview{} = interview) do
    template
    |> take_template_fields(interview)
    |> create_question()
  end

  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
    |> Subscription.broadcast_result()
  end

  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
    |> Subscription.broadcast_result()
  end

  def delete_question(%Question{} = question) do
    Repo.delete(question)
    |> Subscription.broadcast_result()
  end

  def change_question(%Question{} = question, attrs \\ %{}) do
    Question.changeset(question, attrs)
  end
end
