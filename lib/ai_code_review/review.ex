defmodule AiCodeReview.Review do
  @moduledoc """
  The Review context.
  """

  import Ecto.Query, warn: false
  alias AiCodeReview.Repo

  alias AiCodeReview.Review.CodeReview

  @doc """
  Returns the list of reviews.

  ## Examples

      iex> list_reviews()
      [%CodeReview{}, ...]

  """
  def list_reviews do
    Repo.all(CodeReview)
  end

  @doc """
  Gets a single code_review.

  Raises `Ecto.NoResultsError` if the Code review does not exist.

  ## Examples

      iex> get_code_review!(123)
      %CodeReview{}

      iex> get_code_review!(456)
      ** (Ecto.NoResultsError)

  """
  def get_code_review!(id), do: Repo.get!(CodeReview, id)

  @doc """
  Creates a code_review.

  ## Examples

      iex> create_code_review(%{field: value})
      {:ok, %CodeReview{}}

      iex> create_code_review(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_code_review(attrs \\ %{}) do
    %CodeReview{}
    |> CodeReview.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a code_review.

  ## Examples

      iex> update_code_review(code_review, %{field: new_value})
      {:ok, %CodeReview{}}

      iex> update_code_review(code_review, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_code_review(%CodeReview{} = code_review, attrs) do
    code_review
    |> CodeReview.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a code_review.

  ## Examples

      iex> delete_code_review(code_review)
      {:ok, %CodeReview{}}

      iex> delete_code_review(code_review)
      {:error, %Ecto.Changeset{}}

  """
  def delete_code_review(%CodeReview{} = code_review) do
    Repo.delete(code_review)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking code_review changes.

  ## Examples

      iex> change_code_review(code_review)
      %Ecto.Changeset{data: %CodeReview{}}

  """
  def change_code_review(%CodeReview{} = code_review, attrs \\ %{}) do
    CodeReview.changeset(code_review, attrs)
  end
end
