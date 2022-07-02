defmodule SMEInterviews.Answers do
  @moduledoc """
  The Answers context.
  """

  import Ecto.Query, warn: false
  alias SMEInterviews.Repo

  alias SMEInterviews.Answers.Answer
  alias SMEInterviews.Subscription

  def list_answers do
    Repo.all(Answer)
  end

  def get_answer!(id), do: Repo.get!(Answer, id)

  def create_answer(attrs \\ %{}) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
    |> Subscription.broadcast_result()
  end

  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
    |> Subscription.broadcast_result()
  end

  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
    |> Subscription.broadcast_result()
  end

  def change_answer(%Answer{} = answer, attrs \\ %{}) do
    Answer.changeset(answer, attrs)
  end
end
