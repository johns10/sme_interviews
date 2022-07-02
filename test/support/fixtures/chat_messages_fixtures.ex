defmodule SMEInterviews.ChatMessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SMEInterviews.ChatMessages` context.
  """

  @doc """
  Generate a chat_message.
  """
  def chat_message_fixture(attrs \\ %{}) do
    {:ok, chat_message} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> SMEInterviews.ChatMessages.create_chat_message()

    chat_message
  end
end
