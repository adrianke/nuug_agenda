defmodule NuugAgenda.Repo.Migrations.VoteConstraint do
  use Ecto.Migration

  def change do
    create unique_index(:votes, [:proposal_alternative_id, :user_id], name: :vote_constraint)
  end
end
