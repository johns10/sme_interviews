defmodule SmeInterviews.Subscription do
  @moduledoc false
  def broadcast(channel, action, payload) do
    SmeInterviewsWeb.Endpoint.broadcast(channel, action, payload)
  end

  @doc "Broadcasts a screenshot to the team it belongs to"
  def broadcast_result({:error, _changeset} = response), do: response

  def broadcast_result({:ok, %{__meta__: %{state: :deleted}} = struct}) do
    broadcast(channel(struct), "delete", struct)
    {:ok, struct}
  end

  def broadcast_result({:ok, %{inserted_at: same_time, updated_at: same_time} = struct}) do
    broadcast(channel(struct), "create", struct)
    {:ok, struct}
  end

  def broadcast_result({:ok, struct}) do
    broadcast(channel(struct), "update", struct)
    {:ok, struct}
  end

  def struct_type(struct), do: to_string(struct.__struct__) |> String.replace("Elixir.", "")

  def channel(%SmeInterviews.Questions.Question{interview_id: interview_id}) do
    "interview:#{interview_id}"
  end

  def channel(%SmeInterviews.Interviews.Interview{id: id}) do
    "interview:#{id}"
  end

  def channel(%SmeInterviews.Answers.Answer{question_id: question_id}) do
    "question:#{question_id}"
  end

  def channel(%SmeInterviews.ChatMessages.ChatMessage{question_id: question_id}) do
    "question:#{question_id}"
  end

  def channel(%SmeInterviews.InterviewUsers.InterviewUser{interview_id: interview_id}) do
    "interview:#{interview_id}"
  end

  def channel(%SmeInterviews.QuestionTemplates.QuestionTemplate{interview_template_id: id}) do
    "interview_template:#{id}"
  end

  def channel(_), do: raise("#{__MODULE__} Channel call failed")
end
