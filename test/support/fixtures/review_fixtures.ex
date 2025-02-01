defmodule AiCodeReview.ReviewFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AiCodeReview.Review` context.
  """

  @doc """
  Generate a code_review.
  """
  def code_review_fixture(attrs \\ %{}) do
    {:ok, code_review} =
      attrs
      |> Enum.into(%{
        content: "some content",
        response: "some response"
      })
      |> AiCodeReview.Review.create_code_review()

    code_review
  end
end
