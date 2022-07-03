defmodule SmeInterviews.ChatMessages.ChatMessage do
  use Ecto.Schema
  import Ecto.Changeset
  alias SmeInterviews.Questions.Question

  schema "chat_message" do
    field :body, :string

    belongs_to :question, Question

    timestamps()
  end

  @doc false
  def changeset(chat_message, attrs) do
    chat_message
    |> cast(attrs, [:body, :question_id])
    |> validate_required([:body])
    |> foreign_key_constraint(:question_id)
  end
end
