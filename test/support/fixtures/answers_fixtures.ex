defmodule SMEInterviews.AnswersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SMEInterviews.Answers` context.
  """

  @doc """
  Generate a answer.
  """
  def answer_fixture(attrs \\ %{}) do
    {:ok, answer} =
      attrs
      |> Enum.into(%{
        body: "some body",
        order: 42,
        selected: true
      })
      |> SMEInterviews.Answers.create_answer()

    answer
  end
end
