defmodule SmeInterviews.Zoom.OAuthToken.DefaultClient do
  @behaviour SmeInterviews.Zoom.OAuthToken.Client

  def get_new_token(code, verifier) do
    conf =
      Application.get_env(:sme_interviews, SmeInterviews.Zoom)
      |> Enum.into(%{})

    auth = "#{conf.oauth_client_id}:#{conf.oauth_client_secret}"

    headers = %{
      "Content-Type" => "application/x-www-form-urlencoded",
      "Authorization" => "Basic #{Base.encode64(auth)}"
    }

    body = ""

    params = %{
      code: code,
      verifier: verifier,
      redirect_uri: "https://opulent-frizzy-toad.gigalixirapp.com/zoom_app/auth",
      grant_type: "authorization_code"
    }

    response =
      HTTPoison.post!(
        conf.oauth_token_endpoint,
        body,
        headers,
        params: params
      )

    response
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("access_token")
  end

  def expire_token(state) do
    Map.put(state, :token, nil)
  end
end
