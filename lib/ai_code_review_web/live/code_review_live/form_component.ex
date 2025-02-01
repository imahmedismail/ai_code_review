defmodule AiCodeReviewWeb.CodeReviewLive.FormComponent do
  use AiCodeReviewWeb, :live_component

  alias AiCodeReview.Review

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage code_review records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="code_review-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:content]} type="text" label="Content" />
        <.input field={@form[:response]} type="text" label="Response" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Code review</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{code_review: code_review} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Review.change_code_review(code_review))
     end)}
  end

  @impl true
  def handle_event("validate", %{"code_review" => code_review_params}, socket) do
    changeset = Review.change_code_review(socket.assigns.code_review, code_review_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"code_review" => code_review_params}, socket) do
    save_code_review(socket, socket.assigns.action, code_review_params)
  end

  defp save_code_review(socket, :edit, code_review_params) do
    case Review.update_code_review(socket.assigns.code_review, code_review_params) do
      {:ok, code_review} ->
        notify_parent({:saved, code_review})

        {:noreply,
         socket
         |> put_flash(:info, "Code review updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_code_review(socket, :new, code_review_params) do
    case Review.create_code_review(code_review_params) do
      {:ok, code_review} ->
        notify_parent({:saved, code_review})

        {:noreply,
         socket
         |> put_flash(:info, "Code review created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
