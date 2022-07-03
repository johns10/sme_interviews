defmodule SmeInterviews.Repo do
  use Ecto.Repo,
    otp_app: :sme_interviews,
    adapter: Ecto.Adapters.Postgres
end
