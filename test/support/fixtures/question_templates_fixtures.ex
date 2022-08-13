defmodule SmeInterviews.QuestionTemplatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SmeInterviews.QuestionTemplates` context.
  """

  @doc """
  Generate a question_template.
  """
  def question_template_fixture(attrs \\ %{}) do
    {:ok, question_template} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> SmeInterviews.QuestionTemplates.create_question_template()

    question_template
  end
end
