defmodule SMEInterviews.ChatMessages.ChatMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat_message" do
    field :body, :string

    timestamps()
  end

  @doc false
  def changeset(chat_message, attrs) do
    chat_message
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
