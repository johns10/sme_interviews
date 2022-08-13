defmodule SmeInterviews.Zoom.OAuthToken.DefaultClientTest do
	use ExUnit.Case
	alias SmeInterviews.Zoom.OAuthToken.DefaultClient

  describe "DefaultClient returns token from expected API" do
    @tag :integration
    test "works" do
      # assert %{
      #          "scope" => "https://api.oforce.com/internal-api https://api.oforce.com/api"
      #        } =
               DefaultClient.get_new_token("B5cLIMJo4s_jLDKENBcSQ6qO14aCd717g", "")
               |> IO.inspect()
                |> String.split(".")
                |> Enum.at(1)
                |> Base.decode64!()
                |> Jason.decode!()
                |> IO.inspect()
    end
  end
end
