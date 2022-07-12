defmodule SmeInterviews.Interviews do
  @moduledoc """
  The Interviews context.
  """
  import Ecto.Query, warn: false
  alias SmeInterviews.Repo
  alias SmeInterviews.Interviews.Interview
  alias SmeInterviews.Subscription

  @behaviour Bodyguard.Policy

  def authorize(:update_interview, %{id: id}, %{user_id: id}), do: :ok
  def authorize(:update_interview, _user, _interview), do: :error

  def authorize(:show_interview, %{id: id}, %{user_id: id}), do: :ok
  def authorize(:show_interview, user, %{users: %Ecto.Association.NotLoaded{}} = interview) do
    authorize(:show_interview, user, Repo.preload(interview, [:users]))
  end
  def authorize(:show_interview, %{id: id}, %{users: users}) do
    user_ids = Enum.map(users, & &1.id)
    if id in user_ids, do: :ok, else: :error
  end

  def list_interviews(opts \\ []) do
    filters = Keyword.get(opts, :filters, [])

    Interview
    |> maybe_filter_by_user_id(filters[:user_id])
    |> Repo.all()
  end

  defp maybe_filter_by_user_id(query, nil), do: query

  defp maybe_filter_by_user_id(query, user_id) do
    query
    |> join(:left, [i], u in assoc(i, :users))
    |> where([i, u], u.id == ^user_id or i.user_id == ^user_id)
    |> order_by([i, u], asc: :name)
    |> distinct([i, u], i.id)
  end

  def get_interview!(id), do: Repo.get!(Interview, id)

  def get_complete_interview!(id) do
    Interview
    |> where([i], i.id == ^id)
    |> join(:left, [i], q in assoc(i, :questions))
    |> join(:left, [i, q], a in assoc(q, :answers))
    |> preload([i, q, a], questions: {q, answers: a})
    |> Repo.one!()
  end

  def preload_interview(interview, preloads), do: Repo.preload(interview, preloads)

  def create_interview(attrs \\ %{}) do
    %Interview{}
    |> Interview.changeset(attrs)
    |> Repo.insert()
  end

  def update_interview(%Interview{} = interview, attrs) do
    interview
    |> Interview.changeset(attrs)
    |> Repo.update()
    |> Subscription.broadcast_result()
  end

  def delete_interview(%Interview{} = interview) do
    Repo.delete(interview)
  end

  def change_interview(%Interview{} = interview, attrs \\ %{}) do
    Interview.changeset(interview, attrs)
  end
end
