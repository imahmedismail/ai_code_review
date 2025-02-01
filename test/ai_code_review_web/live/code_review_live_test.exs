defmodule AiCodeReviewWeb.CodeReviewLiveTest do
  use AiCodeReviewWeb.ConnCase

  import Phoenix.LiveViewTest
  import AiCodeReview.ReviewFixtures

  @create_attrs %{response: "some response", content: "some content"}
  @update_attrs %{response: "some updated response", content: "some updated content"}
  @invalid_attrs %{response: nil, content: nil}

  defp create_code_review(_) do
    code_review = code_review_fixture()
    %{code_review: code_review}
  end

  describe "Index" do
    setup [:create_code_review]

    test "lists all reviews", %{conn: conn, code_review: code_review} do
      {:ok, _index_live, html} = live(conn, ~p"/reviews")

      assert html =~ "Listing Reviews"
      assert html =~ code_review.response
    end

    test "saves new code_review", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/reviews")

      assert index_live |> element("a", "New Code review") |> render_click() =~
               "New Code review"

      assert_patch(index_live, ~p"/reviews/new")

      assert index_live
             |> form("#code_review-form", code_review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#code_review-form", code_review: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/reviews")

      html = render(index_live)
      assert html =~ "Code review created successfully"
      assert html =~ "some response"
    end

    test "updates code_review in listing", %{conn: conn, code_review: code_review} do
      {:ok, index_live, _html} = live(conn, ~p"/reviews")

      assert index_live |> element("#reviews-#{code_review.id} a", "Edit") |> render_click() =~
               "Edit Code review"

      assert_patch(index_live, ~p"/reviews/#{code_review}/edit")

      assert index_live
             |> form("#code_review-form", code_review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#code_review-form", code_review: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/reviews")

      html = render(index_live)
      assert html =~ "Code review updated successfully"
      assert html =~ "some updated response"
    end

    test "deletes code_review in listing", %{conn: conn, code_review: code_review} do
      {:ok, index_live, _html} = live(conn, ~p"/reviews")

      assert index_live |> element("#reviews-#{code_review.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#reviews-#{code_review.id}")
    end
  end

  describe "Show" do
    setup [:create_code_review]

    test "displays code_review", %{conn: conn, code_review: code_review} do
      {:ok, _show_live, html} = live(conn, ~p"/reviews/#{code_review}")

      assert html =~ "Show Code review"
      assert html =~ code_review.response
    end

    test "updates code_review within modal", %{conn: conn, code_review: code_review} do
      {:ok, show_live, _html} = live(conn, ~p"/reviews/#{code_review}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Code review"

      assert_patch(show_live, ~p"/reviews/#{code_review}/show/edit")

      assert show_live
             |> form("#code_review-form", code_review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#code_review-form", code_review: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/reviews/#{code_review}")

      html = render(show_live)
      assert html =~ "Code review updated successfully"
      assert html =~ "some updated response"
    end
  end
end
