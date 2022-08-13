defmodule SmeInterviews.InterviewTemplatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SmeInterviews.InterviewTemplates` context.
  """

  @doc """
  Generate a interview_template.
  """
  def interview_template_fixture(attrs \\ %{}) do
    {:ok, interview_template} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> SmeInterviews.InterviewTemplates.create_interview_template()

    interview_template
  end
end
