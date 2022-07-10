defmodule SmeInterviews.InterviewUsers do
  @moduledoc """
  The InterviewUsers context.
  """

  import Ecto.Query, warn: false
  alias SmeInterviews.Repo

  alias SmeInterviews.InterviewUsers.InterviewUser
  alias SmeInterviews.InterviewUsers.InterviewUserForm
  alias SmeInterviews.Subscription

  def list_interview_users(opts \\ []) do
    filters = Keyword.get(opts, :filters, [])
    preloads = Keyword.get(opts, :preloads, nil)
    InterviewUser
    |> maybe_filter_by_interview_id(filters[:interview_id])
    |> maybe_preload(preloads)
    |> Repo.all()
  end


  defp maybe_filter_by_interview_id(query, nil), do: query

  defp maybe_filter_by_interview_id(query, interview_id) do
    query
    |> where([iu], iu.interview_id == ^interview_id)
  end

  defp maybe_preload(query, nil), do: query
  defp maybe_preload(query, preloads) do
    query
    |> preload(^preloads)
  end

  def get_interview_user!(id), do: Repo.get!(InterviewUser, id)

  def create_interview_user(attrs \\ %{}) do
    %InterviewUser{}
    |> InterviewUser.changeset(attrs)
    |> Repo.insert()
    |> Subscription.broadcast_result()
  end

  def create_preloaded_interview_user(attrs \\ %{}) do
    %InterviewUser{}
    |> InterviewUser.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, user_interview} -> {:ok, Repo.preload(user_interview, :user)}
      error -> error
    end
    |> Subscription.broadcast_result()
  end

  def create_interview_user_form(attrs \\ %{}) do
    %InterviewUserForm{}
    |> InterviewUserForm.changeset(attrs)
    |> Ecto.Changeset.apply_action(:insert)
  end

  def update_interview_user(%InterviewUser{} = interview_user, attrs) do
    interview_user
    |> InterviewUser.changeset(attrs)
    |> Repo.update()
    |> Subscription.broadcast_result()
  end

  def delete_interview_user(%InterviewUser{} = interview_user) do
    Repo.delete(interview_user)
    |> Subscription.broadcast_result()
  end

  def change_interview_user(%InterviewUser{} = interview_user, attrs \\ %{}) do
    InterviewUser.changeset(interview_user, attrs)
  end

  def change_interview_user_form(%InterviewUserForm{} = interview_user_form, attrs \\ %{}) do
    InterviewUserForm.changeset(interview_user_form, attrs)
  end
end
