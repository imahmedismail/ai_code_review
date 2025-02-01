defmodule AiCodeReview.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :content, :text
      add :response, :text

      timestamps(type: :utc_datetime)
    end
  end
end
