defmodule SmeInterviews.AnswersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SmeInterviews.Answers` context.
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
      |> SmeInterviews.Answers.create_answer()

    answer
  end
end
