defmodule AiCodeReview.Repo do
  use Ecto.Repo,
    otp_app: :ai_code_review,
    adapter: Ecto.Adapters.Postgres
end
