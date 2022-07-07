defmodule SmeInterviews.InterviewUsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SmeInterviews.InterviewUsers` context.
  """

  @doc """
  Generate a interview_user.
  """
  def interview_user_fixture(attrs \\ %{}) do
    {:ok, interview_user} =
      attrs
      |> Enum.into(%{

      })
      |> SmeInterviews.InterviewUsers.create_interview_user()

    interview_user
  end
end
