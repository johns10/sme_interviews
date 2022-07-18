defmodule SmeInterviewsWeb.UserConnectLive do
  alias SmeInterviewsWeb.UserLiveAuth

  def on_mount(:default, _params, session, socket) do
    {:cont, UserLiveAuth.default_assigns(socket, session)}
  end
end
