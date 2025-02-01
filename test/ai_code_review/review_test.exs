defmodule AiCodeReview.ReviewTest do
  use AiCodeReview.DataCase

  alias AiCodeReview.Review

  describe "reviews" do
    alias AiCodeReview.Review.CodeReview

    import AiCodeReview.ReviewFixtures

    @invalid_attrs %{response: nil, content: nil}

    test "list_reviews/0 returns all reviews" do
      code_review = code_review_fixture()
      assert Review.list_reviews() == [code_review]
    end

    test "get_code_review!/1 returns the code_review with given id" do
      code_review = code_review_fixture()
      assert Review.get_code_review!(code_review.id) == code_review
    end

    test "create_code_review/1 with valid data creates a code_review" do
      valid_attrs = %{response: "some response", content: "some content"}

      assert {:ok, %CodeReview{} = code_review} = Review.create_code_review(valid_attrs)
      assert code_review.response == "some response"
      assert code_review.content == "some content"
    end

    test "create_code_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Review.create_code_review(@invalid_attrs)
    end

    test "update_code_review/2 with valid data updates the code_review" do
      code_review = code_review_fixture()
      update_attrs = %{response: "some updated response", content: "some updated content"}

      assert {:ok, %CodeReview{} = code_review} =
               Review.update_code_review(code_review, update_attrs)

      assert code_review.response == "some updated response"
      assert code_review.content == "some updated content"
    end

    test "update_code_review/2 with invalid data returns error changeset" do
      code_review = code_review_fixture()
      assert {:error, %Ecto.Changeset{}} = Review.update_code_review(code_review, @invalid_attrs)
      assert code_review == Review.get_code_review!(code_review.id)
    end

    test "delete_code_review/1 deletes the code_review" do
      code_review = code_review_fixture()
      assert {:ok, %CodeReview{}} = Review.delete_code_review(code_review)
      assert_raise Ecto.NoResultsError, fn -> Review.get_code_review!(code_review.id) end
    end

    test "change_code_review/1 returns a code_review changeset" do
      code_review = code_review_fixture()
      assert %Ecto.Changeset{} = Review.change_code_review(code_review)
    end
  end
end
