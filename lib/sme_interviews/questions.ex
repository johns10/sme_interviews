defmodule SmeInterviews.Questions do
  @moduledoc """
  The Questions context.
  """

  import Ecto.Query, warn: false
  alias SmeInterviews.Repo
  alias SmeInterviews.Subscription
  alias SmeInterviews.Questions.Question

  def list_questions do
    Repo.all(Question)
  end

  def get_question!(id), do: Repo.get!(Question, id)

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
