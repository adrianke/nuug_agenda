defmodule NuugAgenda.Repo.Migrations.Votes do
  use Ecto.Migration

  def change do
    create table("proposals") do
      add :title, :text
      add :description, :text, null: true, default: nil
      add :active, :boolean

      timestamps()
    end

    create table("proposal_alternatives") do
      add :proposal_id, references("proposals")
      add :title, :text

      timestamps()
    end

    create table("users") do
      add :name, :text
      add :password, :string, size: 255

      timestamps()
    end

    create table("votes") do
      add :proposal_alternative_id, references("proposal_alternatives")
      add :user_id, references("users")

      timestamps()
    end
  end
end
