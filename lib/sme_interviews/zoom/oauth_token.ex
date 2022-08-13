defmodule SmeInterviews.Zoom.OAuthToken do
  use GenServer
  alias Insurance.Openforce.OAuthToken.Client
  @default_token_expiration :timer.minutes(55)

  def start_link(opts) do
    token_expiration = Keyword.get(opts, :token_expiration, @default_token_expiration)
    listener = Keyword.get(opts, :listener, self())
    state = %{token: nil, token_expiration: token_expiration, listener: listener}
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def get_token(), do: GenServer.call(__MODULE__, :get_token)

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call(:get_token, _from, %{token: nil, token_expiration: expiration} = state) do
    token = Client.get_new_token()
    Process.send_after(self(), :expire_token, expiration)
    {:reply, token, Map.put(state, :token, token)}
  end

  @impl true
  def handle_call(:get_token, _from, %{token: token} = state) do
    {:reply, token, state}
  end

  @impl true
  def handle_info(:expire_token, state) do
    {:noreply, Client.expire_token(state)}
  end
end
