defmodule SMEInterviews.InterviewsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SMEInterviews.Interviews` context.
  """

  @doc """
  Generate a interview.
  """
  def interview_fixture(attrs \\ %{}) do
    {:ok, interview} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> SMEInterviews.Interviews.create_interview()

    interview
  end
end
