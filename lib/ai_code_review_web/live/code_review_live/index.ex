defmodule AiCodeReviewWeb.CodeReviewLive.Index do
  use AiCodeReviewWeb, :live_view

  alias AiCodeReview.Review
  alias AiCodeReview.Review.CodeReview

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :reviews, Review.list_reviews())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Code review")
    |> assign(:code_review, Review.get_code_review!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Code review")
    |> assign(:code_review, %CodeReview{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reviews")
    |> assign(:code_review, nil)
  end

  @impl true
  def handle_info({AiCodeReviewWeb.CodeReviewLive.FormComponent, {:saved, code_review}}, socket) do
    {:noreply, stream_insert(socket, :reviews, code_review)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    code_review = Review.get_code_review!(id)
    {:ok, _} = Review.delete_code_review(code_review)

    {:noreply, stream_delete(socket, :reviews, code_review)}
  end
end
