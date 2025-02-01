defmodule AiCodeReviewWeb.CodeReviewLive.Show do
  use AiCodeReviewWeb, :live_view

  alias AiCodeReview.Review

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:code_review, Review.get_code_review!(id))}
  end

  defp page_title(:show), do: "Show Code review"
  defp page_title(:edit), do: "Edit Code review"
end
