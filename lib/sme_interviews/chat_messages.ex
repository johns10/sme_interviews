defmodule SMEInterviews.ChatMessages do
  @moduledoc """
  The ChatMessages context.
  """

  import Ecto.Query, warn: false
  alias SMEInterviews.Repo
  alias SMEInterviews.Subscription
  alias SMEInterviews.ChatMessages.ChatMessage

  def list_chat_message(opts \\ []) do
    filters = Keyword.get(opts, :filters, [])

    ChatMessage
    |> maybe_filter_by_question_id(filters[:question_id])
    |> Repo.all()
  end

  defp maybe_filter_by_question_id(query, nil), do: query

  defp maybe_filter_by_question_id(query, question_id) do
    query
    |> where([c], c.question_id == ^question_id)
  end

  def get_chat_message!(id), do: Repo.get!(ChatMessage, id)

  def create_chat_message(attrs \\ %{}) do
    %ChatMessage{}
    |> ChatMessage.changeset(attrs)
    |> Repo.insert()
    |> Subscription.broadcast_result()
  end

  def update_chat_message(%ChatMessage{} = chat_message, attrs) do
    chat_message
    |> ChatMessage.changeset(attrs)
    |> Repo.update()
    |> Subscription.broadcast_result()
  end

  def delete_chat_message(%ChatMessage{} = chat_message) do
    Repo.delete(chat_message)
    |> Subscription.broadcast_result()
  end

  def change_chat_message(%ChatMessage{} = chat_message, attrs \\ %{}) do
    ChatMessage.changeset(chat_message, attrs)
  end
end
