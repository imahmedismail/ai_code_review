defmodule AiCodeReviewWeb.PageController do
  use AiCodeReviewWeb, :controller

  def redirect_to_code_review(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    redirect(conn, to: ~p"/code-review")
  end
end
