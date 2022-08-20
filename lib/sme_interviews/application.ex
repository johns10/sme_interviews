defmodule SmeInterviews.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = children(Mix.env())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SmeInterviews.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SmeInterviewsWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp children(:dev), do: children() ++ [{MinioServer, Application.get_env(:ex_aws, :s3)}]
  defp children(_), do: children()

  defp children() do
    [
      SmeInterviews.Repo,
      SmeInterviewsWeb.Telemetry,
      {Phoenix.PubSub, name: SmeInterviews.PubSub},
      SmeInterviewsWeb.Endpoint
    ]
  end
end
