defmodule SMEInterviews.QuestionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SMEInterviews.Questions` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        body: "some body",
        status: :open
      })
      |> SMEInterviews.Questions.create_question()

    question
  end
end
