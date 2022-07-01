defmodule SMEInterviews.Subscription do
  @moduledoc false
  def broadcast(channel, action, payload) do
    SMEInterviewsWeb.Endpoint.broadcast(channel, action, payload)
  end

  @doc "Broadcasts a screenshot to the team it belongs to"
  def broadcast_result({:error, _changeset} = response), do: response
  def broadcast_result({:ok, %{__meta__: %{state: :deleted}} = struct}) do
    broadcast(channel(struct), "delete", struct)
    {:ok, struct}
  end
  def broadcast_result({:ok, %{inserted_at: same_time, updated_at: same_time} = struct}) do
    IO.puts("sending create on #{channel(struct)}")
    broadcast(channel(struct), "create", struct)
    {:ok, struct}
  end
  def broadcast_result({:ok, struct}) do
    broadcast(channel(struct), "update", struct)
    {:ok, struct}
  end


  def struct_type(struct), do: to_string(struct.__struct__) |> String.replace("Elixir.", "")

  def channel(%SMEInterviews.Questions.Question{interview_id: interview_id}) do
    "interview:#{interview_id}"
  end
  def channel(_), do: raise("#{__MODULE__} Channel call failed")
end
