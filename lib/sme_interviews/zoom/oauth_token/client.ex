defmodule SmeInterviews.Zoom.OAuthToken.Client do
  @callback get_new_token(binary(), binary()) :: binary()
  @callback expire_token(map()) :: map()

  def get_new_token() do
    service = Application.get_env(:sme_interviews, :get_new_token, SmeInterviews.Zoom.OAuthToken.DefaultClient)
    service.get_new_token()
  end

  def expire_token(state) do
    service = Application.get_env(:sme_interviews, :expire_token, SmeInterviews.Zoom.OAuthToken.DefaultClient)
    service.expire_token(state)
  end
end
