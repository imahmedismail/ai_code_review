defmodule AiCodeReview.Review.CodeReview do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :response, :string
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(code_review, attrs) do
    code_review
    |> cast(attrs, [:content, :response])
    |> validate_required([:content, :response])
  end
end
